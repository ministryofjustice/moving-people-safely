require_relative 'entries/prison'

module Seeds
  class PopulatePrisons
    def self.call(options = {})
      new(options).call
    end

    def initialize(options = {})
      @seed_file_path = options.fetch(:seed_file_path, default_seed_file_path)
      @logger = options.fetch(:logger, Rails.logger)
    end

    def call
      logger.info "Seeding #{prison_seeds.size} prisons..."
      seeded = 0
      prison_seeds.each do |prison_seed|
        prison = seed_entry(prison_seed)
        seeded += 1 if prison && prison.persisted?
      end
      logger.info "Seeded #{seeded} prisons."
    end

    private

    attr_reader :seed_file_path, :logger

    def seed_entry(prison_seed)
      entry = Entries::Prison.new(prison_seed)
      Prison.create_with(entry.to_h).find_or_create_by(nomis_id: entry.nomis_id)
    rescue
      logger.error "Error seeding #{prison_seed.inspect}"
      false
    end

    def prison_seeds
      @prison_seeds ||= YAML.load_file(seed_file_path)
    end

    def default_seed_file_path
      File.join(Rails.root, 'db/seeds/prison-estate-records.yaml')
    end
  end
end
