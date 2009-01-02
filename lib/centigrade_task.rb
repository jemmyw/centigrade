require 'fileutils'

module CentigradeTask
  module Attributes
    class AttributeError < Exception
        
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize_attributes(attributes)
      attributes.symbolize_keys!

      @attributes = {}

      self.class.attributes.freeze
      self.class.attributes.each do |key, options|
        if options[:required] && !attributes.has_key?(key)
          raise AttributeError.new('Required attribute not found for %s: %s' % [self.class.name, key])
        end

        @attributes[key] = attributes[key] || options[:default] || nil
      end
    end

    module ClassMethods
      def attribute(name, options = {})
        metaclass.instance_eval do
          @attributes = {:hi => true}

          define_method(:attributes) do
            @attributes ||= {}
          end
        end

        attributes[name] = options

        define_method(name) do
          @attributes[name]
        end
      end
    end
  end

  class Base
    def initialize(path, attributes = {})
      @path = path
      @data_path = File.join(@path, self.class.name)
      FileUtils.mkdir_p(path)

      initialize_attributes(attributes)

      @data = Marshal.load(File.read(@data_path)) if File.exists?(@data_path)
    end

    def execute
      returning execute! do
        File.open(@data_path, 'w') do |file|
          file.write Marshal.dump(data)
        end
      end
    end
      
    def execute!
      raise "Must be implemented by inherited class"
    end

    def data
      @data ||= {}
    end

    def status(*args)
      @status = args.first if args.any?
      @status
    end

    def message(*args)
      @message = args.first if args.any?
      @message
    end
  end

  Base.class_eval do
    include Attributes
  end
end
