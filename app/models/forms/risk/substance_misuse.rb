module Forms
  module Risk
    class SubstanceMisuse < Forms::Base
      optional_field :substance_supply, default: 'unknown'

      validate :valid_trafficking_options, if: proc { |f| f.substance_supply == 'yes' }

      def valid_trafficking_options
        unless selected_trafficking_options.any?
          errors.add(:base, :minimum_one_option, options: trafficking_options.join(', '))
        end
      end

      optional_checkbox :trafficking_drugs
      optional_checkbox :trafficking_alcohol

      reset attributes: %i[trafficking_drugs trafficking_alcohol], if_falsey: :substance_supply

      private

      def selected_trafficking_options
        [trafficking_drugs, trafficking_alcohol]
      end

      def trafficking_options
        translate_options(%i[trafficking_drugs trafficking_alcohol], :substance_misuse)
      end
    end
  end
end
