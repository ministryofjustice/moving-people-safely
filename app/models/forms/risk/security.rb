module Forms
  module Risk
    class Security < Forms::Base
      optional_details_field :controlled_unlock
      optional_field :category_a
      optional_details_field :high_profile
      optional_details_field :pnc_warnings
    end
  end
end
