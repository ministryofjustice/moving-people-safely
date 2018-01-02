require 'rails_helper'

RSpec.describe Risk, type: :model do
  it { is_expected.to be_a(Questionable) }
  it { is_expected.to be_a(Reviewable) }

  it { is_expected.to belong_to(:escort) }

  it { is_expected.to delegate_method(:editable?).to(:escort) }

  subject { described_class.new }

  include_examples 'reviewable'

  describe '#acct_status_text' do
    context 'when acct_status equals closed_in_last_6_months' do
      date_of_most_recently_closed_acct = 1.month.ago.to_date
      subject { build(:risk, acct_status: 'closed_in_last_6_months', date_of_most_recently_closed_acct: date_of_most_recently_closed_acct) }
      its(:acct_status_text) { is_expected.to eq "Closed: #{date_of_most_recently_closed_acct}" }
    end

    context 'when acct_status equals none' do
      date_of_most_recently_closed_acct = 1.month.ago
      subject { build(:risk, acct_status: 'none') }
      its(:acct_status_text) { is_expected.to be_blank }
    end

    context 'when acct_status is not none or closed_in_last_6_months' do
      subject { build(:risk, acct_status: 'open') }
      its(:acct_status_text) { is_expected.to eq 'Open' }
    end
  end
end
