module Seeds
  class MapPrisonNomisToSSO
    def self.call(options = {})
      new(options).call
    end

    def initialize(options = {})
      @map_file_path = options.fetch(:map_file_path, default_map_file_path)
      @logger = options.fetch(:logger, Rails.logger)
    end

    def call
      logger.info "Mapping #{mappings.size} prisons NOMIS id to SSO id..."
      mapped = 0
      mappings.each do |mapping|
        nomis_id = mapping[0]
        sso_id = mapping[1]
        prison = Prison.find_by(nomis_id: nomis_id)
        if prison
          prison.update_attribute(:sso_id, sso_id)
          mapped += 1
        else
          logger.info "[WARN] Prison with NOMIS id #{nomis_id} not found."
        end
      end
      logger.info "Mapped #{mapped} prisons NOMIS id to SSO id."
    end

    private

    attr_reader :map_file_path, :logger

    def mappings
      @mappings ||= YAML.load_file(map_file_path)
    end

    def default_map_file_path
      File.join(Rails.root, 'db/seeds/prison-nomis-sso-mapping.yaml')
    end
  end
end
