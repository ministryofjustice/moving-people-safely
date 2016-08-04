module Forms
  module Risk
    class RiskToSelf < Forms::Base
      optional_field :open_acct
      optional_details_field :suicide
    end
  end
end
