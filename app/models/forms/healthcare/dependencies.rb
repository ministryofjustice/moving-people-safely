# frozen_string_literal: true

module Forms
  module Healthcare
    class Dependencies < Forms::Base
      options_field_with_details :alcohol_withdrawal, if: :from_police?
      options_field_with_details :dependencies
    end
  end
end
