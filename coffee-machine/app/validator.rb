require_relative 'exception'
module App
  module Validator
    private
    # validations for the json
    def self.validate_config(config)
      raise_error if config['machine']&.empty?
      raise_error if config['machine']['outlets']&.empty?
      raise_error if config['machine']['outlets']['count_n'].nil?
      raise_error if config['machine']['total_items_quantity']&.empty?
      raise_error if config['machine']['beverages']&.empty?
    end

    def raise_error
      raise App::InvalidParameter, 'correct machine config not avaible'
    end
  end
end