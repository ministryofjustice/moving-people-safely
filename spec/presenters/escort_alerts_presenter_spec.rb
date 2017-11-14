require 'rails_helper'

RSpec.describe EscortAlertsPresenter, type: :presenter do
  subject { described_class.new(escort) }

  let(:escort) { create(:escort, risk: risk) }

  describe '#acct_status_text' do
    context 'no ACCT status' do
      let(:risk) { create :risk, acct_status: 'none' }
      its(:acct_status_text) { is_expected.to eq '' }
    end

    context 'open ACCT status' do
      let(:risk) { create :risk, acct_status: 'open' }
      its(:acct_status_text) { is_expected.to eq 'Open' }
    end

    context 'recently closed ACCT status' do
      let(:risk) do
        create :risk,
          acct_status: 'closed_in_last_6_months',
          acct_status_details: 'Foo',
          date_of_most_recently_closed_acct: Date.new(2010,1,1)
      end

      its(:acct_status_text) { is_expected.to eq 'Closed on: 01/01/2010 | Foo' }
    end

    context 'closed ACCT status' do
      let(:risk) do
        create :risk,
          acct_status: 'closed',
          acct_status_details: 'Foo',
          date_of_most_recently_closed_acct: Date.new(2010,1,1)
      end

      its(:acct_status_text) { is_expected.to eq 'Closed on: 01/01/2010 | Foo' }
    end
  end

  context 'post closure ACCT status' do
    let(:risk) do
      create :risk,
        acct_status: 'post_closure',
        acct_status_details: nil,
        date_of_most_recently_closed_acct: nil
    end

    its(:acct_status_text) { is_expected.to eq 'Post closure' }
  end
end
