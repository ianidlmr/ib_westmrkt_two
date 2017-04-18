namespace :orders do

  # Sets up logging - should only be called from other rake tasks
  task setup_logger: :environment do
    logger           = Logger.new(STDOUT)
    logger.level     = Logger::INFO
    Rails.logger     = logger
  end

  #------------------------------------------------------------------------------
  # status: Clean up in_progress Order records
  desc 'Clean up in_progress Order records'
  task remove_in_progress: :setup_logger do
    Rails.logger.info("===================")
    Rails.logger.info("orders:remove_in_progress")

    Order.in_progress.where('updated_at <= ?', 20.minutes.ago.utc).each(&:expire!)

    Rails.logger.info('*******************')
  end
end