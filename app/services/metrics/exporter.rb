module Metrics
  class Exporter
    def initialize(calculator, options = {})
      @calculator = calculator
      @api_config = Rails.application.secrets[:geckoboard]
      @logger = options.fetch(:logger, Rails.logger)
    end

    def call
      log_disabled && return unless api_key
      logger.info 'Sending updated metrics to Geckoboard dataset'
      send_dataset(total_escorts_dataset, calculator.total_escorts, 'total escorts')
      send_dataset(escorts_by_date_dataset, calculator.escorts_by_date, 'escorts by date')
    end

    private

    attr_reader :calculator, :api_config, :logger

    def send_dataset(dataset, data, report_name)
      dataset.put(data).tap do |result|
        message_status = result ? 'Successfully sent' : 'Error sending'
        logger.info "#{message_status} #{report_name} metrics to Geckoboard dataset"
      end
    end

    def api_key
      return unless api_config.present?
      api_config['api_key']
    end

    def dataset_prefix
      return unless api_config.present?
      api_config['dataset_prefix']
    end

    def client
      @client ||= Geckoboard.client(api_key)
    end

    def total_escorts_dataset
      @escorts_dataset ||= client.datasets.find_or_create("#{dataset_prefix}.escorts_report", fields: [
        Geckoboard::NumberField.new(:total_initiated_escorts, name: 'Total Initiated Escorts'),
        Geckoboard::NumberField.new(:total_issued_escorts, name: 'Total Issued Escorts'),
        Geckoboard::NumberField.new(:total_unique_detainees_escorted, name: 'Total Unique Detainees Escorted'),
        Geckoboard::NumberField.new(:total_reused_escorts, name: 'Total Re-used Escorts'),
        Geckoboard::NumberField.new(:total_unused_escorts, name: 'Total Unused Escorts')
      ])
    end

    def escorts_by_date_dataset
      @escorts_by_date_dataset ||= client.datasets.find_or_create("#{dataset_prefix}.escorts_by_date_report", fields: [
        Geckoboard::NumberField.new(:total_issued, name: 'Total Issued Escorts'),
        Geckoboard::NumberField.new(:total_not_issued, name: 'Total Not Issued Escorts'),
        Geckoboard::DateField.new(:date, name: 'PER move date')
      ])
    end

    def log_disabled
      logger.info 'Not sending metrics to Geckoboard. Service is not configured!'
    end
  end
end
