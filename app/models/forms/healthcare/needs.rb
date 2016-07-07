module Forms
  module Healthcare
    class Needs < Forms::Base
      optional_details_field :dependencies

      optional_field :medication
      prepopulated_collection :medications
    end
  end
end
