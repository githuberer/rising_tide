#!/usr/bin/env ruby
require_relative 'common'

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
      result = []
      hostname.each { |e| result << self.ssh(script, e) }
      return result
    end
    def subfile(path, content, *hostname)     #def subfile(options={})
      filename = File.basename(path)
      result = []
      result << self.upload_web(filename, content)
      hostname.each { |e| result << self.upload_scp(path, e) }
        return result
        #return result.flatten!(1)
    end
    #def deploy(hostname, package)
    #  package
    #end

  end
end


