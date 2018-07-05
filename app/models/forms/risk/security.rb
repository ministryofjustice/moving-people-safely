module Forms
  module Risk
    class Security < Forms::Base
      options_field_with_details :controlled_unlock
      options_field :category_a, if: :from_prison?
      options_field_with_details :high_profile
      options_field_with_details :pnc_warnings
    end
  end
end
