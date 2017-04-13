namespace :db_cleanup do

  # Sets up logging - should only be called from other rake tasks
  task setup_logger: :environment do
    logger           = Logger.new(STDOUT)
    logger.level     = Logger::INFO
    Rails.logger     = logger
  end

  #------------------------------------------------------------------------------
  # status: Clean up in_progress Order records
  desc 'Clean up in_progress Order records'
  task in_progress_orders: :setup_logger do
    Rails.logger.info("===================")
    Rails.logger.info("db_cleanup:in_progress_orders")

    Order.in_progress.where('updated_at >= ?', 20.minutes.ago.utc).destroy_all

    Rails.logger.info('*******************')
  end
end