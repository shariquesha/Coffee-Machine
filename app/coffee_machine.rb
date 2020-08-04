require_relative 'initializer'
require 'singleton'

# klass for coffee machine
class CoffeeMachine
  extend Initializer
  include Singleton

  attr_reader :inventory, :beverages, :outlets

  def initialize
    CoffeeMachine.load_config
    config = CoffeeMachine.config
    @inventory = config['machine']['total_items_quantity']
    @beverages = config['machine']['beverages']
    @outlets = config['machine']['outlets']['count_n']
    @mutex = Mutex.new
  end

  def serve(orders = [])
    validate_order(orders)
    threads = []
    orders.compact.each do |order|
      threads << Thread.new(order) do |t_order|
        @mutex.synchronize do
          begin
            serve_order(t_order)
          rescue StandardError => e
            puts e.message
          end
        end
      end
    end
    threads.each(&:join)
  end

  def list_beverages
    @beverages.keys.join(' ')
  end

  def refill(items = {})
    validate_refill(items)
    items.each do |key, value|
      @inventory[key.to_s] += value.to_f if value.to_f && @inventory[key.to_s]
    end
  end

  private

  def validate_order(orders)
    raise 'incorrect input provided, expects Array' if orders.class != Array
    raise "machine serves #{@outlets} at a time" if orders.length > @outlets

    invalid_o = orders.reject { |x| @beverages.key?(x) }
    raise "machine does not serve #{invalid_o.join('')}" unless invalid_o.empty?
  end

  def validate_refill(items)
    raise 'incorrect input provided, expects Hash' if items.class != Hash
  end

  def serve_order(t_order)
    temp_inventory = deep_copy(@inventory)
    beverages[t_order].each do |key, value|
      err_msg = "#{t_order} cannot be prepared because #{key}"
      raise "#{err_msg} is not available" if temp_inventory[key].nil?
      raise "#{err_msg} is not sufficient" if temp_inventory[key] < value

      temp_inventory[key] -= value
    end
    @inventory = temp_inventory
    puts "#{t_order} is prepared"
  end

  def deep_copy(old_object)
    new_object = {}
    old_object.each do |key, value|
      new_object[key] = value
    end
    new_object
  end
end
