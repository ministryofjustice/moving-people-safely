module Seeds
  class PopulatePoliceCustody < PopulateBase
    private

    def data_file_name
      'police_custody'
    end

    def human_name_plural
      'police stations & custody suites'
    end

    def create_entry(data)
      PoliceCustody.find_or_create_by(
        name: capitalize_handling_brackets(data[0])
      )
    end

    def capitalize_handling_brackets(str)
      str.split.map do |word|
        # Handle leading bracket
        word.split('(').map { |e| e.empty? ? '(' : e.capitalize } .join
      end.join(' ')
    end
  end
end
