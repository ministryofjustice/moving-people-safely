module Forms
  module Healthcare
    class Social < Forms::Base
      options_field_with_details :personal_care
      options_field_with_details :female_hygiene_kit, if: :female_from_police?
    end
  end
end
