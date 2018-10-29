module Forms
  module Risk
    class Segregation < Forms::Base
      PRISON_CSRA_CHOICES = %w[high standard].freeze
      POLICE_CSRA_CHOICES = %w[yes no].freeze

      options_field :csra, options: :csra_choices
      property :csra_details, type: StrictString
      options_field :rule_45, if: :from_prison?
      options_field_with_details :vulnerable_prisoner

      validates :csra_details, presence: true, if: -> { csra == 'yes' && from_police? }
      reset attributes: %i[csra_details], if_falsey: :csra

      def csra_choices
        return PRISON_CSRA_CHOICES if from_prison?

        POLICE_CSRA_CHOICES
      end
    end
  end
end
