#!/usr/bin/env ruby
require_relative 'helper'


task :checkserverhealth do
  hostname = $hosts.keys
  servers = Helpers::CheckServerHealth.new(*hostname)
  servers.check_process
  servers.check_disk_space
  servers.check_net_traffic
end




