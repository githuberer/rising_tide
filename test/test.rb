#!/usr/bin/env ruby
require_relative '../lib/helpers'
require_relative '../lib/common'
require 'minitest/autorun'

Dir.chdir("../")
puts "app root dir ==> " + Dir.pwd

include View
puts "escape_html ==> " + escape_html(" less than: << ||| new line:\n ||| greater than: >>")

puts "\n\n======================================\n\n"

class TestCommon < MiniTest::Unit::TestCase
  def setup
    @test = Helpers::RisingTide.new
    @hostname = 'v5backup'
    @home_app = '/home/wyy/rising_tide'
  end
  def test_to_ip
    assert_equal '58.215.161.213', @test.to_ip(@hostname)
  end
  def test_ssh
    assert_equal "/etc\n", @test.ssh('ls -d /etc', @hostname)
  end
  def test_uplaod_web
    content0 = "this is a test, #{Time.now}"
    file_content_path = "/home/wyy/test.txt"
    file_uploads_path = "#{@home_app}/uploads/test.txt"
    File.open(file_content_path, 'w') { |f| f.write(content0) }
    content = File.new(file_content_path)
    @test.upload_web("test.txt", content)
    assert_equal content0, File.open(file_uploads_path, 'r') { |f| f.read }
  end
  def test_upload_scp
    assert_equal "*", @test.upload_scp("/u/backup/test.txt", @hostname)
  end
  def test_confile_append
    assert_equal "*", @test.confile_append('api-album.zip', @hostname)
    assert_equal "*", @test.confile_append('web-mc-manager.war', @hostname)
  end

end



