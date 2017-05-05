set :output, '/home/deploy/www/shared/log/cron_log.log'

# Delete in_progress orders every 5 minutes
every 5.minutes do
  rake 'orders:remove_in_progress'
end
