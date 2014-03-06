#!/usr/bin/env ruby
require_relative 'common'

module RisingTide
  class RisingTide < Common
    #private :upgrade_package_from_local
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
    def subfile(path, content, *hostname)     #def subfile("/u/test.txt", content, *["hostname1"])
      filename = File.basename(path)
      result = [] << self.upload_web(filename, content)
      hostname.each { |e| result << self.upload_scp(path, e) }
        return result
        #return result.flatten!(1)
    end

    private
    def upgrade_package_from_local(packname, hostname)
      packname_dotfront = packname.sub(/\..*/, '')
      script = <<-header
      sudo test -x /u/shscript/upgrade-package/#{packname_dotfront}.sh && \
      sudo /u/shscript/upgrade-package/#{packname_dotfront}.sh
      header
      self.upload_scp("/temp/#{packname}", hostname)
      self.ssh(script, hostname)
    end

    public
    def deploy(hostname, *packname)
      if hostname == "v5backup"
        packname.each do |e|
          self.confile_append(e, hostname)
          self.upgrade_package_from_local(e, hostname)
        end
      elsif hostname == "sync"
        packname.each do |e|
          if e == "api-album.zip" or e == "api-yyalbum.war"
            ["v5file", "v5app", "v5app2"].each do |ee|
              self.upgrade_package_from_local(e, ee)
            end
          else
            self.upgrade_package_from_local(e, v5file)
          end
        end
      end
    end


  end  # class end
end    # module end
