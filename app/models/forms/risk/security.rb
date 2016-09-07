module Forms
  module Risk
    class Security < Forms::Base
      optional_details_field :current_e_risk
      validates :current_e_risk_details,
        inclusion: { in: ::Risk.current_e_risk_details_all_values },
        allow_blank: true
      optional_details_field :category_a
      optional_details_field :restricted_status
      property :escape_pack,
        type: Axiom::Types::Boolean, default: false
      property :escape_risk_assessment,
        type: Axiom::Types::Boolean, default: false
      property :cuffing_protocol,
        type: Axiom::Types::Boolean, default: false

      def e_risk_values
        ::Risk.current_e_risk_details_all_values
      end
    end
  end
end
