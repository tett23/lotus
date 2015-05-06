# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

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

set :output, "/home/tett23/projects/lotus/log/whenever.log"
job_type :lotus, "cd :path > /dev/null && source /home/tett23/.rvm/environments/lotus && bin/lotus :task >> /home/tett23/projects/lotus/log/whenever.log 2>> /home/tett23/projects/lotus/log/whenever.error.log"

every 1.minute do
  lotus "process"
end

every 1.day, at: '6am' do
  lotus "load_ts"
end

every 1.day, at: '5am' do
  lotus "get_program"
end
