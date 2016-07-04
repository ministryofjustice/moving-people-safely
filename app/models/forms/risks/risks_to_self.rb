module Forms
  module Risks
    class RisksToSelf < Forms::Base
      optional_details_field :open_acct
      optional_details_field :suicide
    end
  end
end
