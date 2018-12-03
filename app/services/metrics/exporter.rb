# frozen_string_literal: true

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
      send_datasets
    end

    private

    attr_reader :calculator, :api_config, :logger

    def send_datasets
      send_dataset(total_escorts, calculator.total_escorts, 'total escorts')
      send_dataset(escorts_by_date, calculator.escorts_by_date, 'escorts by date')
      send_dataset(hours_saved, calculator.hours_saved, 'hours saved')
      send_dataset(percentage_saved, calculator.percentage_saved, 'percentage saved')
      send_dataset(hours_saved_last_3_months, calculator.hours_saved_last_3_months, 'hours saved in last 3 months')
    end

    def send_dataset(dataset, data, report_name)
      dataset.put(data).tap do |result|
        message_status = result ? 'Successfully sent' : 'Error sending'
        logger.info "#{message_status} #{report_name} metrics to Geckoboard dataset"
      end
    end

    def api_key
      return unless api_config.present?

      api_config[:api_key]
    end

    def dataset_prefix
      return unless api_config.present?

      api_config[:dataset_prefix]
    end

    def client
      @client ||= Geckoboard.client(api_key)
    end

    def total_escorts
      @total_escorts ||= client.datasets.find_or_create("#{dataset_prefix}.escorts_report",
        fields: [
          Geckoboard::NumberField.new(:total_initiated_escorts, name: 'Total Initiated Escorts'),
          Geckoboard::NumberField.new(:total_issued_escorts, name: 'Total Issued Escorts'),
          Geckoboard::NumberField.new(:total_unique_detainees_escorted, name: 'Total Unique Detainees Escorted'),
          Geckoboard::NumberField.new(:total_reused_escorts, name: 'Total Re-used Escorts'),
          Geckoboard::NumberField.new(:total_unused_escorts, name: 'Total Unused Escorts')
        ])
    end

    def escorts_by_date
      @escorts_by_date ||= client.datasets.find_or_create("#{dataset_prefix}.escorts_by_date_report",
        fields: [
          Geckoboard::NumberField.new(:total_issued, name: 'Total Issued Escorts'),
          Geckoboard::NumberField.new(:total_not_issued, name: 'Total Not Issued Escorts'),
          Geckoboard::DateField.new(:date, name: 'PER move date')
        ])
    end

    def hours_saved
      @hours_saved ||= client.datasets.find_or_create("#{dataset_prefix}.hours_saved_report",
        fields: [
          Geckoboard::NumberField.new(:hours_saved, name: 'Hours saved')
        ])
    end

    def percentage_saved
      @percentage_saved ||= client.datasets.find_or_create("#{dataset_prefix}.percentage_saved_report",
        fields: [
          Geckoboard::NumberField.new(:percentage_saved, name: 'Percentage saved through use of ePer')
        ])
    end

    def hours_saved_last_3_months
      @hours_saved_last_3_months ||=
        client.datasets.find_or_create("#{dataset_prefix}.hours_saved_last_3_months_report",
          fields: [
            Geckoboard::StringField.new(:month_name, name: 'Month'),
            Geckoboard::NumberField.new(:hours_saved, name: 'Hours saved')
          ])
    end

    def log_disabled
      logger.info 'Not sending metrics to Geckoboard. Service is not configured!'
    end
  end
end
