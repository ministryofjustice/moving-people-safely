module Forms
  module Risk
    class Violence < Forms::Base
      CONTROLLED_UNLOCK_VALUES = %w[two_officer_unlock three_officer_unlock
                                    four_officer_unlock more_than_four].freeze

      optional_field :violence_due_to_discrimination, default: 'unknown'
      optional_checkbox :risk_to_females
      optional_checkbox :homophobic
      optional_checkbox_with_details :racist, :violence_due_to_discrimination
      optional_checkbox_with_details :other_violence_due_to_discrimination, :violence_due_to_discrimination
      reset attributes: %i[risk_to_females homophobic racist racist_details
                           other_violence_due_to_discrimination other_violence_due_to_discrimination_details],
            if_falsey: :violence_due_to_discrimination

      validate :valid_violence_due_to_discrimination_options,
        if: -> { violence_due_to_discrimination == 'yes' }

      def valid_violence_due_to_discrimination_options
        if selected_violence_due_to_discrimination_options.none?
          errors.add(:base, :minimum_one_option, options: violence_due_to_discrimination_options.join(', '))
        end
      end

      optional_field :violence_to_staff, default: 'unknown'
      optional_checkbox :violence_to_staff_custody
      optional_checkbox :violence_to_staff_community
      reset attributes: %i[violence_to_staff_custody violence_to_staff_community], if_falsey: :violence_to_staff

      validate :valid_violence_to_staff_options,
        if: -> { violence_to_staff == 'yes' }

      def valid_violence_to_staff_options
        if selected_violence_to_staff_options.none?
          errors.add(:base, :minimum_one_option, options: violence_to_staff_options.join(', '))
        end
      end

      optional_field :violence_to_other_detainees, default: 'unknown'
      optional_checkbox_with_details :co_defendant, :violence_to_other_detainees
      optional_checkbox_with_details :gang_member, :violence_to_other_detainees
      optional_checkbox_with_details :other_violence_to_other_detainees, :violence_to_other_detainees
      reset attributes: %i[co_defendant co_defendant_details gang_member
                           gang_member_details other_violence_to_other_detainees
                           other_violence_to_other_detainees_details],
            if_falsey: :violence_to_other_detainees

      validate :valid_violence_to_other_detainees_options,
        if: -> { violence_to_other_detainees == 'yes' }

      def valid_violence_to_other_detainees_options
        if selected_violence_to_other_detainees_options.none?
          errors.add(:base, :minimum_one_option, options: violence_to_other_detainees_options.join(', '))
        end
      end

      optional_details_field :violence_to_general_public, default: 'unknown'

      optional_field :controlled_unlock_required, default: 'unknown'
      reset attributes: %i[controlled_unlock controlled_unlock_details],
            if_falsey: :controlled_unlock_required

      property :controlled_unlock, type: StrictString
      validates :controlled_unlock,
        inclusion: { in: CONTROLLED_UNLOCK_VALUES }, if: -> { controlled_unlock_required == 'yes' }

      property :controlled_unlock_details, type: StrictString
      validates :controlled_unlock_details,
        presence: true, if: -> { controlled_unlock_required == 'yes' }

      private

      def selected_violence_due_to_discrimination_options
        [risk_to_females,
         homophobic,
         racist,
         other_violence_due_to_discrimination]
      end

      def violence_due_to_discrimination_options
        translate_options(%i[risk_to_females homophobic racist other_violence_due_to_discrimination], :violence)
      end

      def selected_violence_to_staff_options
        [violence_to_staff_custody,
         violence_to_staff_community]
      end

      def violence_to_staff_options
        translate_options(%i[violence_to_staff_custody violence_to_staff_community], :violence)
      end

      def selected_violence_to_other_detainees_options
        [co_defendant, gang_member, other_violence_to_other_detainees]
      end

      def violence_to_other_detainees_options
        translate_options(%i[co_defendant gang_member other_violence_to_other_detainees], :violence)
      end

      def controlled_unlock_options
        translate_options(%i[two_officer_unlock three_officer_unlock four_officer_unlock more_than_four], :violence)
      end
    end
  end
end
