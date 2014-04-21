#!/usr/bin/env ruby
require_relative 'helpers'

# exec command: rake task_name
# example: rake check_server_health

task :check_server_health do
  hostname = $hosts.keys
  servers = Helpers::CheckServerHealth.new(hostname)
  servers.check_process
  servers.check_disk_space
  servers.check_net_traffic
end




