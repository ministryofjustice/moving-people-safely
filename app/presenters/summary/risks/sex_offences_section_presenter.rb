module Summary
  module Risks
    class SexOffencesSectionPresenter < RiskPresenter
      def details_for(*)
        "#{victim_type}. #{details}" if sex_offence_checked?
      end

      private

      def sex_offence_checked?
        public_send(:sex_offence) == 'yes'
      end

      def victim_type
        public_send(:sex_offence_victim).humanize
      end

      def details
        public_send(:sex_offence_details)
      end
    end
  end
end
