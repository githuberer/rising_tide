#!/usr/bin/env ruby
require 'fileutils'
require_relative 'base'

module Rearrange
  extend self
  def upload_to_download
    t = Time.now
    sourcefiles = Dir.glob("upload/*").select { |e| File.file?(e) }
    targetdir = "download/#{t.strftime("%Y-%m-%d")}"

    unless sourcefiles.empty?
      FileUtils.mkdir_p(targetdir) unless Dir.exist?(targetdir)
      FileUtils.mv(sourcefiles, targetdir)
    end
  end
  def clear_download
    t = Time.now.strftime("%Y%m%d")
    dirs = Dir.glob("download/????-??-??").select do |d|
      d.gsub(/(download\/|-)/, '').to_i < t.to_i-100
    end
    dirs.each { |e| FileUtils.rmtree(e) }
  end
end



