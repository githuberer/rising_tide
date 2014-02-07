#!/usr/bin/env ruby
require_relative 'config'
require 'net/ssh'
require 'net/scp'
require 'cgi'


module View
  def escape_html(text)
    CGI.escapeHTML(text).sub("\n", "<br>")
  end
end


module QueryServer
  def to_hosts(*hostname)
    hosts = {}.merge!( $hosts.select {|k,v| hostname.include?(k)} )
    return hosts
  end
  def ssh(script, *hostname)
    result = []
    hosts = self.to_hosts(*hostname)
    hosts.each_key do |e|
      ip = hosts[e]
      Net::SSH.start(
        ip,
        $user_ssh,
        :password => $password_ssh,
        :port => $port_ssh
      ) do |ssh| 
        result << [ e, ip, script, ssh.exec!(script) ]
      end
    end
=begin
    if result.length == 1 and result[0].is_a?(Array)
      return result.flatten
    else
      return result
    end
=end
    return result
  end
  def upload(filename, content)
    path = "uploads/#{filename}"
    File.open(path, 'w') { |f| f.write(content.read) }
    if File.exists?(path)
      return "upload sucessed: " + path
    else
      return "upload filed: " + path
    end
  end
  def scp(path, *hostname)
    filename = File.basename(path)
    result = []
    result << self.ssh("[[ -f /temp/#{filename} ]] && sudo rm -rf /temp/#{filename}", *hostname)
    hosts = self.to_hosts(*hostname)
    hosts.each_key do |e|
      Net::SCP.start(
        hosts[e],
        $user_ssh,
        :password => $password_ssh, 
        :port => $port_ssh,
      ) { |scp| scp.upload!( "uploads/#{filename}", "/temp" ) }
    end
    result << self.ssh("sudo cp /temp/#{filename} #{path}", *hostname)
    return result
  end
end


module Helpers
  include View
  class RisingTide
    include QueryServer
    def redis_flush(*hostname)
      script = <<-header
        cd /u/db/redis-2.4.3 && \
        sudo -u redis ./client.sh <<EOF
        flushall
        quit
EOF
      header
      self.ssh(script, *hostname)
    end
    #def subfile(options={})
    def subfile(path, content, *hostname)
      filename = File.basename(path)
      result = []
      result << self.upload(filename, content)
      result << self.scp(path, *hostname)
      return result.flatten!(2)
    end
  end
end


