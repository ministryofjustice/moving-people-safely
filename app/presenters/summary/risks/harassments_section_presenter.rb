module Summary
  module Risks
    class HarassmentsSectionPresenter < RiskPresenter
      def answer_for(attribute)
        if harassments_question_unanswered?
          "<span class='text-error'>Missing</span>"
        elsif harassments_question_answered_yes? && checkbox_checked?(attribute)
          '<b>Yes</b>'
        else
          'No'
        end
      end

      private

      def harassments_question_unanswered?
        harassments_value == 'unknown'
      end

      def harassments_question_answered_yes?
        harassments_value == 'yes'
      end

      def harassments_value
        public_send(:stalker_harasser_bully)
      end

      def checkbox_checked?(attribute)
        public_send(attribute) == true
      end
    end
  end
end
