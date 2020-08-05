require_relative 'initializer'
require_relative 'exception'
require 'singleton'

module App
  # klass for coffee machine
  class CoffeeMachine
    extend Initializer
    include Validator

    attr_reader :inventory, :beverages, :outlets, :capacity

    def initialize(machine_config)
      Validator.validate_config(machine_config)
      config = machine_config
      @capacity = deep_copy(config['machine']['total_items_quantity'])
      @inventory = deep_copy(@capacity)
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

    def refill(items = {})
      validate_refill(items)
      items.each do |key, value|
        return unless value.to_f && @inventory[key.to_s]

        new_value = @inventory[key.to_s] + value.to_f
        @inventory[key.to_s] += value.to_f
      end
    end

    def indicator
      items_left_in_inventory = {}
      @inventory.each do |key, value|
        percentage = (value / @capacity[key].to_f) * 100
        items_left_in_inventory[key] = percentage.to_s + '%'
      end
      items_left_in_inventory
    end

    private

    def validate_order(orders)
      raise App::InvalidParameter, 'incorrect input provided, expects Array' if orders.class != Array
      raise App::InvalidParameter, "machine serves #{@outlets} at a time" if orders.length > @outlets

      invalid_o = orders.reject { |x| @beverages.key?(x) }
      raise App::InvalidParameter, "machine does not serve #{invalid_o.join('')}" unless invalid_o.empty?
    end

    def validate_refill(items)
      raise App::InvalidParameter, 'incorrect input provided, expects Hash' if items.class != Hash
      items.each do |key, value|
        raise App::InvalidParameter, "invalid refill item '#{key}' provided" unless value.to_f && @inventory[key.to_s]
        raise App::InvalidParameter, "negative amount provided for #{key}" if value && value.to_f < 0
        left_space = @capacity[key.to_s] - @inventory[key.to_s]
        raise App::InvalidParameter, "#{key} overflow, left space is #{left_space} ml" if left_space < value.to_f
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
end
