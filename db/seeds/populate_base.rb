require 'csv'

module Seeds
  class PopulateBase
    def self.call(options = {})
      new(options).call
    end

    def initialize(options = {})
      @seed_file_path = options.fetch(:seed_file_path, default_seed_file_path)
      @logger = options.fetch(:logger, Rails.logger)
    end

    def call
      logger.info "Seeding #{seeds.size} #{human_name_plural}..."
      seeded = 0

      seeds.each do |data|
        record = process_entry(data)
        seeded += 1 if record && record.persisted?
      end

      logger.info "Seeded #{seeded} #{human_name_plural}."
    end

    private

    attr_reader :seed_file_path, :logger

    def process_entry(data)
      create_entry(data)
    rescue
      logger.error "Error seeding #{data.inspect}"
      raise
      false
    end

    def seeds
      @seeds ||= CSV.read(seed_file_path)
    end

    def default_seed_file_path
      File.join(Rails.root, "db/seeds/#{data_file_name}.csv")
    end
  end
end
