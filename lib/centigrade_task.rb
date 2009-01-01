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

      self.class.attributes.each do |key, options|
        if options[:required] && !attributes.has_key?(key)
          raise AttributeError.new('Required attribute not found: %s' % key)
        end

        @attributes[key] = attributes[key] || options[:default] || nil
      end
    end

    module ClassMethods
      def attribute(name, options = {})
        attributes[name] = options
          
        define_method(name) do |*params|
          @attributes[name]
        end
      end

      def attributes
        @@attributes ||= {}
      end
    end
  end

  class Base
    attr_reader :status, :message

    def initialize(attributes = {})
      initialize_attributes(attributes)
    end

    def execute(project, task)
      @project = project
      @task = task
      execute!
    end
      
    def execute!

    end
    
    private
    attr_writer :status, :message
  end

  Base.class_eval do
    include Attributes
  end
end
