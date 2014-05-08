#!/usr/bin/env ruby
require 'fileutils'
require_relative 'base'

module Rearrange
  @t = Time.now
  def self.upload_to_download
    sourcefiles = Dir.glob("upload/*").select { |e| File.file?(e) }
    targetdir = "download/#{@t.strftime("%Y-%m-%d")}"

    FileUtils.mkdir_p(targetdir) unless Dir.exist?(targetdir)
    FileUtils.mv(sourcefiles, targetdir)
  end
  def self.clear_download
    t = @t.strftime("%Y%m%d")
    dirs = Dir.glob("download/????-??-??").select do |d|
      d.gsub(/(download\/|-)/, '').to_i < t.to_i-100
    end
    dirs.each { |e| FileUtils.rmtree(e) }
  end
end



