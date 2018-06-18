module Seeds
  class PopulateYouthSecureEstates < PopulateCsvBase
    private

    def data_file_name
      'youth_secure_estates'
    end

    def human_name_plural
      'youth secure estates'
    end

    def create_entry(data)
      YouthSecureEstate.find_or_create_by(name: data[0])
      # TODO Do we need to remove any leading HMP/YOI?
      # TODO Do we need to remove these from prisons?
    end
  end
end
