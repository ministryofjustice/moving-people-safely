module Forms
  module Risk
    class ConcealedWeapons < Forms::Base
      optional_details_field :conceals_weapons, default: 'unknown'
      optional_details_field :conceals_drugs, default: 'unknown'
      optional_field :conceals_mobile_phone_or_other_items, default: 'unknown'
      optional_checkbox :conceals_mobile_phones
      optional_checkbox :conceals_sim_cards
      optional_checkbox_with_details :conceals_other_items, :conceals_mobile_phone_or_other_items
      reset attributes: %i[
        conceals_mobile_phones conceals_sim_cards
        conceals_other_items conceals_other_items_details
      ], if_falsey: :conceals_mobile_phone_or_other_items

      validate :valid_conceals_mobile_phone_or_other_items_options,
        if: -> { conceals_mobile_phone_or_other_items == 'yes' }

      def valid_conceals_mobile_phone_or_other_items_options
        if selected_conceals_mobile_phone_or_other_items_options.none?
          errors.add(:base, :minimum_one_option, options: conceals_mobile_phone_or_other_items_options.join(', '))
        end
      end

      private

      def selected_conceals_mobile_phone_or_other_items_options
        [conceals_mobile_phones,
         conceals_sim_cards,
         conceals_other_items]
      end

      def conceals_mobile_phone_or_other_items_options
        translate_options(%i[conceals_mobile_phones conceals_sim_cards conceals_other_items], :concealed_weapons)
      end
    end
  end
end
