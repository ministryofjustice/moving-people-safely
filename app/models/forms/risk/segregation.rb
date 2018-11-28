module Forms
  module Risk
    class Segregation < Forms::Base
      PRISON_CSRA_CHOICES = %w[high standard].freeze

      options_field :csra, options: :csra_choices, if: :from_prison?
      options_field :rule_45, if: :from_prison?
      options_field_with_details :vulnerable_prisoner

      def csra_choices
        PRISON_CSRA_CHOICES
      end
    end
  end
end
