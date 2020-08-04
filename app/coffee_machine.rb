require_relative 'initializer'
require 'singleton'

# klass for coffee machine
class CoffeeMachine
  extend Initializer
  include Singleton

  attr_accessor :inventory, :beverages, :outlets

  def initialize
    CoffeeMachine.load_config
    config = CoffeeMachine.config
    set_inventory(config)
    set_beverages(config)
    @inventory = config['machine']['total_items_quantity']
    @beverages = config['machine']['beverages']
    @outlets = config['machine']['outlets']['count_n']
    @mutex = Mutex.new
  end

  def serve(orders)
    threads = []
    orders.each do |order|
      threads << Thread.new(order) do |t_order|
        @mutex.synchronize do
          validate_and_update(t_order)
        end
      end
    end
  end
  threads.each { |x| x.join }
end

private

def validate_and_update(t_order)
  is_failed = false
  temp_inventory = @inventory
  errors = []
  beverages[t_order].each do |item|
    if temp_inventory[item] >= beverages[item]
      temp_inventory[item] -= beverages[item]
    elsif temp_inventory[item].nil?
      is_failed = true
      errors << "#{t_order} cannot be prepared because #{item} is not available"
    else
      is_failed = true
      errors << "#{t_order} cannot be prepared because #{item} is not sufficient"
    end
  end
  raise errors.join(',') if is_failed

  @inventory = temp_inventory
end
