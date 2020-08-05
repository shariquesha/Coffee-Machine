require_relative 'initializer'
require_relative 'exception'
require 'singleton'

# klass for coffee machine
class CoffeeMachine
  extend Initializer
  include Singleton

  attr_reader :inventory, :beverages, :outlets

  def initialize
    config = read_config_file
    @inventory = config['machine']['total_items_quantity']
    @beverages = config['machine']['beverages']
    @outlets = config['machine']['outlets']['count_n']
    @mutex = Mutex.new
  end

  def serve(orders = [])
    validate_order(orders)
    threads = []
    outputs = []
    orders.compact.each do |order|
      threads << Thread.new(order) do |t_order|
        @mutex.synchronize do
          begin
            outputs << serve_order(t_order)
          rescue StandardError => e
            outputs <<  e.message
          end
        end
      end
    end
    threads.each(&:join)
    outputs
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

  def indicator
    config = read_config_file
    total_items_quantity = config['machine']['total_items_quantity']
    items_left_in_inventory = {}
    @inventory.each do |key, value|
      percentage = (value / total_items_quantity[key].to_f) * 100
      items_left_in_inventory[key] = percentage.to_s + '%'
    end
    items_left_in_inventory
  end

  private

  def read_config_file
    CoffeeMachine.load_config
    CoffeeMachine.config
  end

  def validate_order(orders)
    raise InvalidParameter, 'incorrect input provided, expects Array' if orders.class != Array
    raise InvalidParameter, "machine serves #{@outlets} at a time" if orders.length > @outlets

    invalid_o = orders.reject { |x| @beverages.key?(x) }
    raise InvalidParameter, "machine does not serve #{invalid_o.join('')}" unless invalid_o.empty?
  end

  def validate_refill(items)
    raise InvalidParameter, 'incorrect input provided, expects Hash' if items.class != Hash
    items.each do |_key, value|
      raise InvalidParameter, 'incorrect input provided, expects positive number' if value < 0
    end
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
    "#{t_order} is prepared"
  end

  def deep_copy(old_object)
    new_object = {}
    old_object.each do |key, value|
      new_object[key] = value
    end
    new_object
  end
end
