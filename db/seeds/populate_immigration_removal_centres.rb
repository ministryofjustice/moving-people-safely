module Seeds
  class PopulateImmigrationRemovalCentres < PopulateCsvBase
    private

    def data_file_name
      'immigration_removal_centres'
    end

    def human_name_plural
      'immigration removal centres'
    end

    def create_entry(data)
      ImmigrationRemovalCentre.find_or_create_by(name: data[0])
    end
  end
end
