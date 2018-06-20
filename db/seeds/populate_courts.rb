module Seeds
  class PopulateCourts < PopulateCsvBase
    private

    def data_file_name
      'courts'
    end

    def human_name_plural
      'courts'
    end

    def create_entry(data)
      court_klass = data[2].gsub("\s", '').constantize
      court_klass.find_or_create_by(name: data[1])
    end
  end
end
