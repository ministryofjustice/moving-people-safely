require 'rails_helper'

RSpec.describe RiskWorkflow do
  subject { described_class.new }
  specify { expect(subject.type).to eq('risk') }
  include_examples 'workflow'

  describe '.sections' do
    specify {
      expect(described_class.sections).to match_array(%i[risk_to_self risk_from_others violence hostage_taker harassments sex_offences non_association_markers security substance_misuse concealed_weapons arson communication])
    }
  end

  describe '.mandatory_questions' do
    it 'returns the appropriate list of mandatory questions' do
      expect(described_class.mandatory_questions).to match_array(
          %w[ acct_status rule_45 csra victim_of_abuse high_profile violence_due_to_discrimination
              violence_to_staff violence_to_other_detainees violence_to_general_public
              hostage_taker harassment intimidation sex_offence non_association_markers
              current_e_risk category_a
              restricted_status substance_supply substance_use conceals_weapons arson
              damage_to_property interpreter_required hearing_speach_sight
              can_read_and_write ])
    end
  end
end
