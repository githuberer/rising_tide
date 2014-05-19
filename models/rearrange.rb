#!/usr/bin/env ruby
require 'fileutils'
require_relative 'base'

module Rearrange
  def self.upload_to_download
    t = Time.now
    sourcefiles = Dir.glob("upload/*").select { |e| File.file?(e) }
    targetdir = "download/#{t.strftime("%Y-%m-%d")}"

    unless sourcefiles.empty?
      FileUtils.mkdir_p(targetdir) unless Dir.exist?(targetdir)
    end
    FileUtils.mv(sourcefiles, targetdir)
  end
  def self.clear_download
    t = Time.now.strftime("%Y%m%d")
    dirs = Dir.glob("download/????-??-??").select do |d|
      d.gsub(/(download\/|-)/, '').to_i < t.to_i-100
    end
    dirs.each { |e| FileUtils.rmtree(e) }
  end
end



