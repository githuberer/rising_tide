#!/usr/bin/env ruby
require 'net/ssh'
require 'net/scp'
require 'mysql2'
require 'zip'
require 'cgi'
require_relative '../config/main'


class Base

  protected
  def escape_html(text)
    CGI.escapeHTML(text).sub("\n", "<br>")
  end

  def to_ip(hostname)
    $hosts[hostname]
  end

  def ssh(script, hostname)
    ip = to_ip(hostname)
    Net::SSH.start(
      ip,
      $ssh_user,
      :password => $ssh_password,
      :port => $ssh_port
    ) { |ssh| ssh.exec!(script) }
  end

  def upload_web(filename, content)
    path = "upload/#{filename}"
    File.open(path, 'w') { |f| f.write(content.read) }
  end

  def upload_scp(path, hostname)        # path example(remote server's file path) => : "/u/bak/ttt.html" 
    filename = File.basename(path)
    result = []
    result << ssh("[[ -f /temp/#{filename} ]] && sudo rm -rf /temp/#{filename}", hostname)
    ip = to_ip(hostname)

    Net::SCP.start(
      ip,
      $ssh_user,
      :password => $ssh_password, 
      :port => $ssh_port,
    ) { |scp| result << scp.upload!( "upload/#{filename}", "/temp/#{filename}" ) }

    result << ssh("sudo cp /temp/#{filename} #{path}", hostname) unless path =~ /^\/temp/
    result
  end


  def mysql_select(ip, database, table, ids)  # ids is an array
    client = Mysql2::Client.new(
      :host => ip,
      :username => $mysql_user,
      :password => $mysql_password,
      :database => database
    )
    records = client.query(
      "SELECT * FROM #{table} 
      WHERE om_id in ( #{ids.join(", ")} )" 
    )
    records
  end

  def mysql_query(ip, database, sqlcmds) # sqlcmds is an Array
    client = Mysql2::Client.new(
      :flags => Mysql2::Client::MULTI_STATEMENTS,
      :host => ip,
      :username => $mysql_user,
      :password => $mysql_password,
      :database => database
    )

    record = client.query("#{sqlcmds.join("; ")}")

    results = []
    results << record.first
    while record.next_result
      results << record.first
    end

    results
  end

end


