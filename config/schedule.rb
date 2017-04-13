set :output, '/home/deploy/www/shared/log/cron_log.log'

# Delete in_progress orders every 20 minutes
every 20.minutes do
  rake 'db_cleanup:in_progress_orders'
end