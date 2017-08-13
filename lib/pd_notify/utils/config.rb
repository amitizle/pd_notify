require 'yaml'
require 'singleton'

module PdNotify
  module Utils
    class Config
      include Singleton

      attr_accessor :items
      attr_accessor :default_items

      def Config.init(config_file_path, default_config_file_path)
        instance.items = YAML.load_file(config_file_path)
        instance.default_items = YAML.load_file(default_config_file_path)
        instance
      end

      def _dump
        File.write(@config_file_path, YAML.dump(@items))
      end

      def get(key)
        @items[key]
      end

      def default(key)
        @default_items[key]
      end
    end
  end
end
