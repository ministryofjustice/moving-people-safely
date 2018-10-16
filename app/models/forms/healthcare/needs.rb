# frozen_string_literal: true

module Forms
  module Healthcare
    class Needs < Forms::Base
      options_field :has_medications
      prepopulated_collection :medications
    end
  end
end
