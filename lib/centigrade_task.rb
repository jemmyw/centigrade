require 'fileutils'

module CentigradeTask
  module Attributes
    class AttributeArray < DelegateClass(Array)
      def initialize
        super(Array.new)
      end

      def [](*n)
        n.length > 1 || n.first.is_a?(Fixnum) ? super(*n) : detect{|attr| attr[:name] == n.first }
      end
    end

    class AttributeError < Exception
        
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize_attributes(attributes)
      attributes.symbolize_keys!

      @attributes = {}

      self.class.attributes.freeze
      self.class.attributes.each do |options|
        if options[:required] && !attributes.has_key?(options[:name])
          raise AttributeError.new('Required attribute not found for %s: %s' % [self.class.name, options[:name]])
        end

        @attributes[options[:name]] = attributes[options[:name]] || options[:default] || nil
      end
    end

    module ClassMethods
      def attributes
        AttributeArray.new
      end

      def attribute(name, options = {})
        metaclass.instance_eval do
          @attributes = {:hi => true}

          define_method(:attributes) do
            @attributes ||= AttributeArray.new
          end
        end

        options[:name] = name
        attributes.push(options)

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
