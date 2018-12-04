# frozen_string_literal: true

module Forms
  module Healthcare
    class Social < Forms::Base
      options_field_with_details :personal_care
      options_field :female_hygiene_kit, if: :female?
    end
  end
end
