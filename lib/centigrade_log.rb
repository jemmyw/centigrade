require 'logger'

module Centigrade
  module Log
    module InstanceMethods
      def logger
        self.class.logger
      end
    end
    
    module ClassMethods
      def logger
        @logger ||= Logger.new('log/centigrade_daemon.log')
      end

      def logger=(value)
        @logger = value
      end
    end

    def self.included(mod)
      mod.class_eval do
        include(InstanceMethods)
        extend(ClassMethods)
      end
    end
  end
end