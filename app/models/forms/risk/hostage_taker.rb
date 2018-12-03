# frozen_string_literal: true

module Forms
  module Risk
    class HostageTaker < Forms::Base
      options_field_with_details :hostage_taker
      options_field_with_details :sex_offence, if: :from_police?
      options_field :arson, if: :from_police?
    end
  end
end
