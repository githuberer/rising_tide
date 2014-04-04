#!/usr/bin/env ruby
# This is an example file of config.rb
# Modify variables below and then execute shell command: 'mv config-example.rb config.rb'

$port_ssh = '22'
$user_ssh = 'user1'
$password_ssh = "password1"

# hosts
$hosts = {
  "v5app" => "192.168.1.1",
  "v5app2" => "192.168.1.2",
  "v5file" => "192.168.1.3",
  "v5backup" => "192.168.1.4",
  "v5db2" =>  "192.168.1.5", 
  "v5db" => "192.168.1.6"
}

$user_mysql = 'user2'
$password_mysql = 'password2'
$database = 'test'
$table = 'test'
$fields_filepath = %w{ om_path lyric_url karaoke_url intonation_url lrc }


