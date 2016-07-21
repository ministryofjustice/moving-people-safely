module Forms
  module Risk
    class Security < Forms::Base
      optional_details_field :current_e_risk
      optional_details_field :escape_list
      optional_details_field :other_escape_risk_info
      optional_details_field :category_a
      optional_details_field :restricted_status
      property :escape_pack,
        type: Axiom::Types::Boolean, default: false
      property :escape_risk_assessment,
        type: Axiom::Types::Boolean, default: false
      property :cuffing_protocol,
        type: Axiom::Types::Boolean, default: false
    end
  end
end
