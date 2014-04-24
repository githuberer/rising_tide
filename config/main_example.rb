#!/usr/bin/env ruby

# app admin
$rtm_user = 'admin'
$rtm_password = 'admin'

# ssh
$ssh_port = '22'
$ssh_user = 'sshuser'
$ssh_password = "passwd"

$hosts = {
  "v5app" => "192.168.1.0",
  "v5app1" => "192.168.1.1",
  "v5app2" => "192.168.1.2",
  "v5app3" => "192.168.1.3",
  "v5db" => "192.168.1.4",
  "v5db2" => "192.168.1.5",
  "v5f" => "192.168.1.10",
}

# deploy
$packnames = %w[
  name1.zip
  name2.war
  name3.war
]

# sync_mc_om
$master = 'v5db'
$slave = 'v5db2'
$fileserver = 'v5f'
$mysql_user = 'mysql'
$mysql_password = '1234'
$database = 'test'
$table = 'test'
$fields = %w[ om_path test lrc ]  # filepaths: used for sync files


