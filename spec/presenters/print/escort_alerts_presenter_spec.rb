require 'rails_helper'

RSpec.describe Print::EscortAlertsPresenter, type: :presenter do
  let(:move) { create(:move, not_for_release: not_for_release, not_for_release_reason: not_for_release_reason, not_for_release_reason_details: not_for_release_reason_details) }
  let(:escort) { create(:escort, move: move) }
  let(:not_for_release_reason) { 'Violent' }
  let(:not_for_release_reason_details) { nil }

  subject(:presenter) { described_class.new(escort, view) }

  describe "not_for_release_alert" do
    context "when not for release is set to yes" do
      let(:not_for_release) { 'yes' }

      it "shows the reason not for release" do
        expect(presenter.not_for_release_alert).to include "<span class=\"alert-text\">Violent</span>"
      end

      context 'reason is other' do
        let(:not_for_release_reason) { 'other' }
        let(:not_for_release_reason_details) { 'Reason details' }

        it "shows the reason details" do
          expect(presenter.not_for_release_alert).to include "<span class=\"alert-text\">Other (Reason details)</span>"
        end

      end
    end

    context "when not for release is set to no" do
      let(:not_for_release) { 'no' }

      it "does not show the reason not for release" do
        expect(presenter.not_for_release_alert).to eq "<div class=\"alert-wrapper\"><div class=\"image alert-off\"><span class=\"alert-title\">Not for release</span></div></div>"
      end
    end
  end
end
