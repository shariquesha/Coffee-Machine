require 'json'
require_relative 'exception'
require_relative 'validator'

# Application initializer using config file
# it loads json file from config/machine.json
module App
  module Initializer
    include Validator

    class << self
      # load confing file
      def load_config(file_path = nil)
        path = file_path || File.join(File.dirname(__dir__), 'config/machine.json')
        config_file = File.open(path)
        config = JSON.load config_file
        config_file.close
        Validator.validate_config(config)
        config
      rescue StandardError => e
        raise App::InvalidParameter, "\n\n Error while reading config file:  #{e.message}"
      end
    end
  end
end
