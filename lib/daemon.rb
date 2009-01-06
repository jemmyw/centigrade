#!/usr/bin/env ruby

require 'rubygems'
require 'daemons'
require 'config/environment'
require 'logger'

ActiveRecord::Base.logger = Logger.new(STDOUT)

module Centigrade
  module Daemon
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    module_function :logger
  end
end

include Centigrade::Daemon

#Daemons.daemonize

@projects = Project.all
logger.info "Found %d projects" % @projects.size

#@threads = @projects.collect do |project|
#  Thread.new { project.execute }
#end
#
#@threads.each do |thread|
#  thread.join
#end

@projects.each do |project|
  project.execute
end

logger.info "Exiting!"