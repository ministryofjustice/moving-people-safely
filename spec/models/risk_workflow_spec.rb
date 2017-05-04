require 'rails_helper'

RSpec.describe RiskWorkflow do
  subject { described_class.new }
  specify { expect(subject.type).to eq('risk') }
  include_examples 'workflow'

  describe '.sections' do
    specify {
      expect(described_class.sections)
        .to match_array(%w[risk_to_self risk_from_others violence hostage_taker
                           harassments sex_offences security
                           substance_misuse concealed_weapons arson other_risk])
    }
  end

  describe '.mandatory_questions' do
    it 'returns the appropriate list of mandatory questions' do
      expect(described_class.mandatory_questions).to match_array(
          %w[acct_status rule_45 csra victim_of_abuse high_profile violence_due_to_discrimination
             violence_to_staff violence_to_other_detainees violence_to_general_public controlled_unlock_required
             hostage_taker harassment intimidation sex_offence
             current_e_risk previous_escape_attempts category_a escort_risk_assessment
             escape_pack substance_supply conceals_weapons conceals_drugs
             conceals_mobile_phone_or_other_items arson other_risk])
    end
  end
end
