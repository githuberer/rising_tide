#!/usr/bin/env ruby
require_relative 'base'

module Main
  class Main < Base
    def redis_flush(hostname)
      script = <<-header
        cd /u/db/redis-2.4.3 && \
        sudo -u redis ./client.sh <<EOF
        flushall
        quit
EOF
      header
      result = []
      hostname.each { |e| result << ssh(script, e) }
      result
    end
    def subfile(path, content, hostname)     #def subfile("/u/test.txt", content, ["hostname1", "h2"])
      filename = File.basename(path)
      result = [] << upload_web(filename, content)
      hostname.each { |e| result << upload_scp(path, e) }
      result
      #result.flatten!(1)
    end

  end
end
