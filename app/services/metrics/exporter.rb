module Metrics
  class Exporter
    def initialize(metrics, options = {})
      @metrics = metrics
      @api_config = Rails.application.secrets[:geckoboard]
      @logger = options.fetch(:logger, Rails.logger)
    end

    def call
      log_disabled && return unless api_key
      logger.info 'Sending updated metrics to Geckoboard dataset'
      dataset.put(metrics).tap do |result|
        message_status = result ? 'Successfully sent' : 'Error sending'
        logger.info "#{message_status} metrics to Geckoboard dataset"
      end
    end

    private

    attr_reader :metrics, :api_config, :logger

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

    def dataset
      @dataset ||= client.datasets.find_or_create("#{dataset_prefix}.escorts_report", fields: [
        Geckoboard::NumberField.new(:total_initiated_escorts, name: 'Total Initiated Escorts'),
        Geckoboard::NumberField.new(:total_issued_escorts, name: 'Total Issued Escorts'),
        Geckoboard::NumberField.new(:total_unique_detainees_escorted, name: 'Total Unique Detainees Escorted'),
        Geckoboard::NumberField.new(:total_reused_escorts, name: 'Total Re-used Escorts'),
        Geckoboard::NumberField.new(:total_unused_escorts, name: 'Total Unused Escorts')
      ])
    end

    def log_disabled
      logger.info 'Not sending metrics to Geckoboard. Service is not configured!'
    end
  end
end
