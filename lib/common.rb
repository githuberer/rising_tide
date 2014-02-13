#!/usr/bin/env ruby
require_relative '../config'
require 'net/ssh'
require 'net/scp'
require 'cgi'


module View
  def escape_html(text)
    CGI.escapeHTML(text).sub("\n", "<br>")
  end
end


module QueryServer
  def to_ip(hostname)
    $hosts[hostname]
  end
  def ssh(script, hostname)
    ip = self.to_ip(hostname)
    Net::SSH.start(
      ip,
      $user_ssh,
      :password => $password_ssh,
      :port => $port_ssh
    ) { |ssh| return ssh.exec!(script) }
  end
  def upload_web(filename, content)
    path = "uploads/#{filename}"
    return File.open(path, 'w') { |f| f.write(content.read) }
  end
  def upload_scp(path, hostname)
    filename = File.basename(path)

    result = []

    result << self.ssh("[[ -f /temp/#{filename} ]] && sudo rm -rf /temp/#{filename}", hostname)

    ip = self.to_ip(hostname)
    Net::SCP.start(
      ip,
      $user_ssh,
      :password => $password_ssh, 
      :port => $port_ssh,
    ) { |scp| result << scp.upload!( "uploads/#{filename}", "/temp" ) }

    result << self.ssh("sudo cp /temp/#{filename} #{path}", hostname)

    return result
  end
end

