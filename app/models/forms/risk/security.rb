module Forms
  module Risk
    class Security < Forms::Base
      E_RISK_VALUES = %w[e_list_standard e_list_escort e_list_heightened].freeze
      optional_details_field :current_e_risk
      validates :current_e_risk_details,
        inclusion: { in: E_RISK_VALUES },
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
        E_RISK_VALUES
      end
    end
  end
end
