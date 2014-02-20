#!/usr/bin/env ruby
require_relative '../config'
require 'net/ssh'
require 'net/scp'
require 'zip'
require 'cgi'


module View
  def escape_html(text)
    CGI.escapeHTML(text).sub("\n", "<br>")
  end
end


class Model
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
  def upload_scp(path, hostname)    # path => remote path: "/u/bak/ttt.html" 
    filename = File.basename(path)
    result = []
    result << self.ssh("[[ -f /temp/#{filename} ]] && sudo rm -rf /temp/#{filename}", hostname)
    ip = self.to_ip(hostname)

    Net::SCP.start(
      ip,
      $user_ssh,
      :password => $password_ssh, 
      :port => $port_ssh,
    ) { |scp| result << scp.upload!( "uploads/#{filename}", "/temp/#{filename}" ) }

    result << self.ssh("sudo cp /temp/#{filename} #{path}", hostname) unless path =~ /^\/temp/
    return result
  end
  def confile_append(packname, hostname)
    packname_dotfront = packname.sub(/\..*/, '')
    package_path = "uploads/#{packname}"
    confile_path_system = "uploads/#{hostname}-config.properties/#{packname_dotfront}"
    confile_path_package = if packname == "api-album.zip"
                             "#{packname_dotfront}/config.properties"
                           else
                             "WEB-INF/classes/config.properties"
                           end
    Zip.continue_on_exists_proc = true  # configure rubyzip to overwrite existing files while creating a .zip file
    Zip::File.open(package_path, Zip::File::CREATE) do |f|
      f.add(confile_path_package, confile_path_system)
    end
  end

end



