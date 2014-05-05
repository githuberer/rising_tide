#!/usr/bin/env ruby
require_relative 'base'


module Deploy
  class Deploy < Base
    def initialize(packname, content, action, confile_content=nil)
      @packname, @content, @action = packname, content, action
      @packname_dotfront = packname.sub(/\.\w+$/, '')
      @confile_content = confile_content
    end

    protected
    def upload
      upload_web(@packname, @content)
    end

    def confile_modify(hostname, content)
      content_add = {}
      content.split("\n").each do |e|
        if e =~ /.+=.+/
          a = e.split("=", 2).map { |e| e.strip }
          content_add.store(*a)
        end
      end

      confile_uri_system = "upload/#{hostname}-config.properties/#{@packname_dotfront}"
      confile = {}
      IO.readlines(confile_uri_system).each do |e|
        if e =~ /.+=.+/
          a = e.split("=", 2).map { |e| e.strip }
          confile.store(*a)
        end
      end

      confile.merge!(content_add)

      File.open(confile_uri_system, 'w') do |f|
        confile.each { |k,v| f.write("#{k}=#{v}\n") }
      end
    end


    def confile_append(hostname)
      package_uri = "upload/#{@packname}"
      confile_uri_system = "upload/#{hostname}-config.properties/#{@packname_dotfront}"
      confile_uri_package = if @packname == "api-album.zip"
                               "#{@packname_dotfront}/config.properties"
                             else
                               "WEB-INF/classes/config.properties"
                             end
      Zip.continue_on_exists_proc = true  # configure rubyzip to overwrite existing files while creating a .zip file
      #Zip::File.open(package_uri, Zip::File::CREATE) do |f|
      Zip::File.open(package_uri) do |f|
        f.add(confile_uri_package, confile_uri_system)
      end
    end

    def update_package(hostname)
      script = <<-EOF
      sudo /u/shscript/update-package/#{@packname_dotfront}.sh
      EOF
      upload_scp("/temp/#{@packname}", hostname)
      ssh(script, hostname)
    end


    public
    def deploy
      upload
      if @action == (hostname = "v5backup")
        confile_modify(hostname, @confile_content) if @confile_content
        confile_append(hostname)
        upload_scp("/temp/#{@packname}", hostname)
        update_package(hostname)
      elsif @action == "sync"
        case @packname
        when "api-album.zip", "api-yyalbum.war"
          ["v5file", "v5app", "v5app2"].each {|e| update_package(e) }
        else
          update_package("v5file")
        end
      end
    end

  end
end


