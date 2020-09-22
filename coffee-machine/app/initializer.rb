require 'json'
require_relative 'exception'

# Application initializer using config file provided in args
# if file not provided it loads json file from config/machine.json
module App
  module Initializer

    class << self
      # load confing file
      # @param String, file path
      # @return Hash, file contents
      def load_config(file_path = nil)
        path = file_path || File.join(File.dirname(__dir__), 'config/machine.json')
        config_file = File.open(path)
        config = JSON.load config_file
        config_file.close
        validate_config(config)
        config
      rescue StandardError => e
        raise App::InvalidParameter, "\n\n Error while reading config file:  #{e.message}"
      end
    end
  end
end
