require 'csv'

module Seeds
  class PopulateCourts
    def self.call(options = {})
      new(options).call
    end

    def initialize(options = {})
      @seed_file_path = options.fetch(:seed_file_path, default_seed_file_path)
      @logger = options.fetch(:logger, Rails.logger)
    end

    def call
      logger.info "Seeding #{court_seeds.size} courts..."
      seeded = 0
      court_seeds.each do |court_data|
        court = create_entry(court_data)
        seeded += 1 if court && court.persisted?
      end
      logger.info "Seeded #{seeded} courts."
    end

    private

    attr_reader :seed_file_path, :logger

    def create_entry(data)
      court_klass = data[2].gsub("\s", '').constantize
      court_klass.find_or_create_by(name: data[1])
    rescue
      logger.error "Error seeding #{data.inspect}"
      raise
      false
    end

    def court_seeds
      @court_seeds ||= CSV.read(seed_file_path)
    end

    def default_seed_file_path
      File.join(Rails.root, 'db/seeds/courts.csv')
    end
  end
end
