module Forms
  module Risk
    class Segregation < Forms::Base
      CSRA_CHOICES = %w[high standard].freeze

      optional_field :csra, options: CSRA_CHOICES
      optional_field :rule_45
      optional_details_field :vulnerable_prisoner

      def csra_choices
        CSRA_CHOICES
      end
    end
  end
end
