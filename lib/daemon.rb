#!/usr/bin/env ruby

require 'rubygems'
require 'daemons'
require 'config/environment'
require 'centigrade_log'

# ActiveRecord::Base.logger = Logger.new(STDOUT)

include Centigrade::Log

#Daemons.daemonize

@projects = Project.all
logger.info "Found %d projects" % @projects.size
@pipelines = @projects.collect(&:pipelines).flatten
logger.info "Found %d pipelines" % @pipelines.size

$centigrade_running = true

trap('INT') do
  $centigrade_running = false
  logger.info "Waiting for threads to finish"
end

@threads = @pipelines.collect do |pipeline|
  Thread.new do
    while $centigrade_running
      pipeline.execute
      30.times do
        sleep(1)
        break unless $centigrade_running
      end
    end
  end
end

@threads << Thread.new do
  30.times do
    sleep(1)
    break unless $centigrade_running
  end

  logger.info "Centigrade Status"
  logger.info "================="
  logger.info "Threads: %d" % @threads.size
end

@threads.each do |thread|
  thread.join
end

logger.info "Exiting, goodbye!"