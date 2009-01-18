#!/usr/bin/env ruby

require 'config/environment'
require 'centigrade_log'

module Centigrade
  class Daemon
    include Centigrade::Log

    $centigrade_running = true

    def run
      trap('INT') do
        $centigrade_running = false
        logger.info "Waiting for threads to finish"
      end

      @projects = Project.all
      logger.info "Found %d projects" % @projects.size
      @pipelines = @projects.collect(&:pipelines).flatten
      logger.info "Found %d pipelines" % @pipelines.size

      @threads = @pipelines.collect do |pipeline|
        Thread.new do
          while $centigrade_running
            pipeline.execute
            30.times do
              sleep(1)
            end
          end
        end
      end

      @status_thread = Thread.new do
        while true
          30.times do
            sleep(1)
            break unless $centigrade_running
          end

          logger.info "Centigrade Status"
          logger.info "================="
          logger.info "Threads: %d" % @threads.size

          unless $centigrade_running
            Thread.exclusive do
              @threads.each do |thread|
                thread.exit
              end

              Thread.exit
            end
          end
        end
      end

      @status_thread.join

      logger.info "Exiting, goodbye!"
    end
  end
end