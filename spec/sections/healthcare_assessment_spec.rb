require 'rails_helper'

RSpec.describe HealthcareAssessment do
  describe '.section_for' do
    context 'when the section does not exist' do
      specify {
        expect{
          described_class.section_for(:non_existent_section)
        }.to raise_error(NameError, /uninitialized constant HealthcareAssessment::NonExistentSectionSection/)
      }
    end

    context 'when the section exists' do
      module HealthcareAssessment
        class TestSection
        end
      end

      specify {
        expect(described_class.section_for(:test)).to be_instance_of(HealthcareAssessment::TestSection)
      }
    end
  end
end
