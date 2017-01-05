require 'rails_helper'

RSpec.describe HealthcareWorkflow do
  subject { described_class.new }
  specify { expect(subject.type).to eq('healthcare') }
  include_examples 'workflow'

  describe '.sections' do
    specify {
      expect(described_class.sections)
        .to match_array(%i[physical mental social allergies needs transport communication contact])
    }
  end

  describe '.sections_for_summary' do
    specify {
      expect(described_class.sections_for_summary)
        .to match_array(%i[physical mental social allergies needs transport communication])
    }
  end

  describe '.mandatory_questions' do
    it 'returns the appropriate list of mandatory questions' do
      expect(described_class.mandatory_questions).to match_array(
          %w[physical_issues mental_illness phobias personal_hygiene
             personal_care allergies dependencies has_medications
             hearing_speech_sight_issues reading_writing_issues mpv])
    end
  end
end
