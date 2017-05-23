module Forms
  module Healthcare
    class Needs < Forms::Base
      optional_field :has_medications
      prepopulated_collection :medications
    end
  end
end
