#!/usr/bin/env ruby
require_relative 'rising_tide'

include View
test = Helpers::RisingTide.new
content = File.new("/home/wyy/test.txt")


puts "\n\ntest.module: View:::>M"
puts "\n\ntest.escape_html:::"
puts escape_html "<< \n >> \n http://www.google.com.hk"


puts "\n\ntest.module: QueryServer:::>M"

puts "\n\ntest.to_hosts:::"
puts  test.to_hosts(*["v5backup", "v5db"]).inspect

puts "\n\ntest.ssh:::\n"
puts test.ssh("ls -ld /etc", *["v5backup", "v5db"]).inspect


puts "\n\ntest.upload:::\n" 
puts test.upload("testfile", content).inspect

puts "\n\ntest.scp:::\n" 
File.open('/home/wyy/Dropbox/rising_tide/uploads/a_test', 'w') { |f| f.write("a test") }
puts test.scp("/u/bak/a_test", *["v5backup"]).inspect



puts "\n\ntest.class: RisingTide:::>C"

puts "\n\ntest.redis_flush:::\n"
puts  test.redis_flush(*["v5backup"]).inspect

puts "\n\ntest.subfile:::\n" 
puts test.subfile("/u/bak/a_test", content, *["v5backup"]).inspect


