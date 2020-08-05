require 'json'
require_relative 'exception'

# Application initializer using config file
# it loads json file from config/machine.json
module Initializer
  @config = {}

  # load confing file
  def load_config
    config_file = File.open('config/machine.json')
    @config = JSON.load config_file
    config_file.close
    validate_config
  rescue StandardError => e
    raise InvalidParameter, "\n\n Error while reading config file:  #{e.message}"
  end

  # getter for @config variable
  def config
    @config
  end

  private

  # validations for the json
  def validate_config
    raise_error if @config['machine'].empty?
    raise_error if @config['machine']['outlets'].empty?
    raise_error if @config['machine']['outlets']['count_n'].nil?
    raise_error if @config['machine']['total_items_quantity'].empty?
    raise_error if @config['machine']['beverages'].empty?
  end

  def raise_error
    raise InvalidParameter, 'correct machine config not avaible'
  end
end
