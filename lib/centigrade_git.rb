require 'git'

module Centigrade
  class Git
    def initialize(options)
      @options = options
    end

    def up_to_date?
      begin
        g = ::Git.open(@options[:path])
        g.fetch
        r = g.checkout("master")
        if r =~ /is behind.*by (\d+) commit/i
          $1.to_i == 0
        else
          true
        end
      rescue ArgumentError
        false
      end
    end

    def log
      g = ::Git.open(@options[:path])
      g.checkout("master")

      log = []

      g.log.each do |l|
        log << l
      end
      
      log
    end

    def clone
      ::Git.clone(@options[:url], @options[:path])
    end

    def pull
      g = ::Git.open(@options[:path])
      g.checkout("master")
      g.pull
    end

    def clone_or_pull
      begin
        ::Git.open(@options[:path])
        pull
      rescue ArgumentError
        clone
      end
    end
  end
end