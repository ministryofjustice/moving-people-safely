module Forms
  module Healthcare
    class Social < Forms::Base
      optional_details_field :personal_hygiene
      optional_details_field :personal_care
    end
  end
end
