require 'rails_helper'

RSpec.describe Forms::Risk::RiskToSelf, type: :form do
  let(:model) { build(:risk, escort: escort) }

  subject(:form) { described_class.new(model) }

  context 'from prison' do
    let(:escort) { build(:escort, :from_prison) }

    context 'ACCT status' do
      context 'not set' do
        before { form.acct_status = nil }

        it 'requires presence of ACCT status' do
          expect(form).not_to be_valid
          expect(form.errors[:acct_status])
            .to match_array(['^Enter ACCT status'])
        end
      end

      context 'set to closed' do
        before { form.acct_status = 'closed' }

        it 'requires presence of ACCT status details' do
          expect(form).not_to be_valid
          expect(form.errors[:acct_status_details])
            .to match_array(['^Enter ACCT details'])
        end

        it 'requires presence of date of most recently closed ACCT' do
          expect(form).not_to be_valid
          expect(form.errors[:date_of_most_recently_closed_acct])
            .to match_array(['^Enter the date of the most recently closed ACCT'])
        end
      end

      context 'set to open' do
        before { form.acct_status = 'open' }

        it 'valid' do
          expect(form).to be_valid
        end
      end
    end
  end

  context 'from police' do
    let(:escort) { build(:escort, :from_police) }

    context 'observation level' do
      context 'not set' do
        before { form.observation_level = nil }

        it 'suitable error' do
          expect(form).not_to be_valid
          expect(form.errors[:observation_level])
            .to match_array(['^You must select an observation level'])
        end
      end

      context 'set to level 2' do
        before { form.observation_level = 'level2' }

        context 'observation level details left blank' do
          it 'suitable error' do
            expect(form).not_to be_valid
            expect(form.errors[:observation_level_details])
            .to match_array(['^You must enter a reason for the heightened observation'])
          end
        end

        context 'observation level details filled in' do
          before { form.observation_level_details = 'some info' }

          it 'valid' do
            expect(form).to be_valid
          end
        end
      end

      context 'set to level 1' do
        before { form.observation_level = 'level1' }

        it 'valid' do
          expect(form).to be_valid
        end
      end
    end
  end
end
