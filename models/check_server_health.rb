#!/usr/bin/env ruby
require_relative 'base'


module CheckServerHealth
  class CheckServerHealth < Base
    def initialize(hostname)  # hostname is an Array
      @hostname = hostname
    end

    protected
    def produce_file(cmd, filename)
      file = "upload/check_server_health/#{filename}"
      dir = File.dirname(file)
      Dir.mkdir(dir) if ! Dir.exist?(dir)
      File.delete(file) if File.exist?(file)

      @hostname.each do |e| 
        content = <<-EOF.gsub(/^ +/, "")
        \n\n
        #{e}
        ===========================
        #{ssh(cmd, e)}
        \n\n
        EOF

        File.open(file, 'a') { |f| f.write content }
      end
    end

    public
    def check_disk_space
      cmd = "df -h"

      produce_file(cmd, "#{__callee__}.txt")
    end
    def check_net_traffic
      cmd = <<-EOF
      vnstat -h
      vnstat -d|grep #{Time.now.strftime "%m/%d/%y"}
      EOF

      produce_file(cmd, "#{__callee__}.txt")
    end
    def check_process
      cmd = "ps -eo command --sort command"

      produce_file(cmd, "#{__callee__}.txt")
    end
  end
end



