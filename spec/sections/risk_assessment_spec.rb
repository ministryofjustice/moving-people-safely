require 'rails_helper'

RSpec.describe RiskAssessment do
  describe '.section_for' do
    context 'when the section does not exist' do
      specify {
        expect{
          described_class.section_for(:non_existent_section)
        }.to raise_error(NameError, /uninitialized constant RiskAssessment::NonExistentSectionSection/)
      }
    end

    context 'when the section exists' do
      module RiskAssessment
        class TestSection
        end
      end

      specify {
        expect(described_class.section_for(:test)).to be_instance_of(RiskAssessment::TestSection)
      }
    end
  end
end
