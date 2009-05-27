#!/usr/bin/env ruby

require 'rubygems'
require 'ostruct'
require 'optparse' 

class WorkerManagerOptions
  def self.parse(args)
    options = OpenStruct.new
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} <command> [options]"
      opts.separator " "
      opts.separator "  where <command> is one of:"
      opts.separator "     start            start a worker"
      opts.separator "     stop             stop all workers"
      opts.separator "     restart          restart workers"
      opts.separator " "
      opts.separator "  and [options] are:"

      opts.on('-w', '--workers N', 'number of workers to spin up') do |workers|
        options.workers = workers.to_i
      end
    end

    begin
      opts.parse!(args)
    rescue
      puts e.message.capitalize + "\n\n"
      puts opts
      exit 1
    end

    options.workers ||= 5

    unless %w(start stop restart).include?(args[0])
      puts opts
      exit 1
    end

    options
  end
end


module Daemons
  class PidFile 
    # we override this method so creating pid files is fork-safe
    def filename 
      File.join(@dir, "#{@progname}#{Process.pid}.pid")
    end
  end
end
