# frozen_string_literal: true

module Forms
  module Risk
    class ViolentOrDangerous < Forms::Base
      options_field_with_details :violent_or_dangerous, if: :from_prison?
    end
  end
end
