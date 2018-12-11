require 'rails_helper'

RSpec.describe Forms::Risk::Segregation, type: :form do
  let(:model) { build(:risk, escort: escort) }

  subject(:form) { described_class.new(model) }

  context 'from prison' do
    let(:escort) { build(:escort, :from_prison) }

    context 'Rule 45' do
      context 'not set' do
        before { form.rule_45 = nil }

        it 'requires presence of ACCT status' do
          expect(form).not_to be_valid
          expect(form.errors[:rule_45])
            .to match_array(['^Answer the segregation question'])
        end
      end

      context 'set to yes' do
        before { form.rule_45 = 'yes' }

        it 'requires presence of rule 45 details' do
          expect(form).not_to be_valid
          expect(form.errors[:rule_45_details])
            .to match_array(['^Enter segregation details'])
        end
      end
    end
  end
end
