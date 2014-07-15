# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
#
# Update crontab on linux, exec command:
# whenever -i

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#
############################################
# Update crontab on linux, exec command below:
# whenever -i
############################################
set :output, "logs/whenever.log"


=begin
every :day, :at => '1am' do
  rake "check_server_health"
end
=end

every :day, :at => '9pm' do
  rake "rearrange_upload_to_download"
end

every :day, :at => '10pm' do
  rake "clear_download"
end


