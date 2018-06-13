module Escorts
  module DeleteHistoricUnissued
    def call(options = {})
      logger = options.fetch(:logger, Rails.logger)
      scope = Escort.active.where('date(now()) - date(date) >= 1')
      count = scope.count
      logger.info("Soft deleting #{count} unissued escorts past their date")
      scope.in_batches.update_all(deleted_at: Time.now.utc)
      logger.info("Soft deleted #{count} unissued escorts")
    end
    module_function :call
  end
end
