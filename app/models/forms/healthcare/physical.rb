module Forms
  module Healthcare
    class Physical < Forms::Base
      options_field_with_details :pregnant, if: :female_from_police?
      options_field_with_details :physical_issues
    end
  end
end
