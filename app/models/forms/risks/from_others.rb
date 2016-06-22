module Forms
  module Risks
    class FromOthers < Forms::Base
      optional_details_field :rule_45
      optional_details_field :csra
      optional_details_field :verbal_abuse
      optional_details_field :physical_abuse
    end
  end
end
