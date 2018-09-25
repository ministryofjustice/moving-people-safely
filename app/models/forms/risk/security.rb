module Forms
  module Risk
    class Security < Forms::Base
      options_field_with_details :controlled_unlock, if: :from_prison?
      options_field_with_details :high_profile
      options_field_with_details :violent_or_dangerous, if: :from_police?
      options_field_with_details :previous_escape_attempts, if: :from_police?
      options_field_with_details :gang_member, if: :from_police?
      options_field_with_details :pnc_warnings, if: :from_prison?
    end
  end
end
