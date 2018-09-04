require 'rails_helper'

RSpec.describe Escort do
  it { should have_attached_file(:document) }
  it { should validate_attachment_content_type(:document).allowing('application/pdf') }

  describe 'default scope' do
    it 'returns only the escorts that have not been deleted' do
      create_list(:escort, 2)
      create(:escort, deleted_at: 1.hour.ago)
      expect(described_class.unscoped.count).to eq(3)
      expect(described_class.count).to eq(2)
    end
  end

  specify { is_expected.to have_one(:risk) }
  specify { is_expected.to have_one(:healthcare) }

  it { is_expected.to delegate_method(:surname).to(:detainee).with_prefix(true) }
  it { is_expected.to delegate_method(:forenames).to(:detainee).with_prefix(true) }
  it { is_expected.to delegate_method(:full_name).to(:canceller).with_prefix(true) }
  it { is_expected.to delegate_method(:date).to(:move).with_prefix(true) }

  describe '#completed?' do
    let(:risk) { create(:risk) }
    let(:healthcare) { create(:healthcare) }
    let(:offences_workflow) { create(:offences_workflow) }
    let(:detainee) { create(:detainee) }
    let(:move) { create(:move) }
    let(:escort) { create(:escort, detainee: detainee, move: move, risk: risk, healthcare: healthcare, offences_workflow: offences_workflow) }

    specify {
      escort = create(:escort, :completed)
      expect(escort).to be_completed
    }

    context 'when detainee info is not complete' do
      let(:detainee) { create(:detainee, surname: nil) }
      specify { expect(escort).not_to be_completed }
    end

    context 'when move info is not complete' do
      let(:move) { create(:move, date: nil) }
      specify { expect(escort).not_to be_completed }
    end

    context 'when risk assessment is not complete' do
      let(:risk) { create(:risk, :incomplete) }
      specify { expect(escort).not_to be_completed }
    end

    context 'when healthcare assessment is not complete' do
      let(:healthcare) { create(:healthcare, :incomplete) }
      specify { expect(escort).not_to be_completed }
    end

    context 'when offences info is not complete' do
      let(:offences_workflow) { create(:offences_workflow) }
      specify { expect(escort).not_to be_completed }
    end
  end

  describe '#expired?' do
    context 'for an expired escort' do
      let(:escort) { create(:escort, :expired) }
      specify { expect(escort).to be_expired }
    end

    context 'when the escort has not expired' do
      let(:escort) { create(:escort, :with_move) }
      specify { expect(escort).to_not be_expired }
    end
  end

  describe '#cancelled?' do
    context 'for a newly created escort' do
      let(:escort) { create(:escort) }
      specify { expect(escort).not_to be_cancelled }
    end

    context 'when the escort has been cancelled' do
      let(:escort) { create(:escort, cancelled_at: 1.day.ago) }
      specify { expect(escort).to be_cancelled }
    end
  end

  describe '#editable?' do
    context 'when is already issued' do
      let(:escort) { create(:escort, :issued) }
      specify { expect(escort).not_to be_editable }
    end

    context 'when is already cancelled' do
      let(:escort) { create(:escort, :cancelled) }
      specify { expect(escort).not_to be_editable }
    end

    context 'when is not cancelled or issued' do
      let(:escort) { create(:escort) }
      specify { expect(escort).to be_editable }
    end
  end

  describe '#cancel!' do
    let(:escort) { create(:escort) }
    let(:user) { create(:user) }
    let(:reason) { 'Started by mistake' }

    context 'when the escort is already cancelled' do
      let(:cancel_date) { 3.days.ago }
      let(:escort) { create(:escort, cancelled_at: cancel_date) }

      it 'raises an AlreadyCancelledError' do
        expect { escort.cancel!(user, reason) }.to raise_error(Escort::AlreadyCancelledError)
      end

      it 'keeps the current cancel date' do
        expect { escort.cancel!(user, reason) rescue nil }
          .not_to change { escort.reload.cancelled_at.to_i }.from(cancel_date.to_i)
      end
    end

    context 'when the escort is not cancelled or issued yet' do
      let(:escort) { create(:escort) }

      it 'marks the escort as cancelled' do
        time = Time.now.utc
        expect { escort.cancel!(user, reason) }
          .to change { escort.reload.cancelled_at }.from(nil)
        expect(escort.cancelled_at).to be >= time
      end

      it 'stores the reason and the user who cancelled it' do
        escort.cancel!(user, reason)
        expect(escort.canceller).to eq user
        expect(escort.cancelling_reason).to eq reason
      end
    end
  end


  describe '#issued?' do
    context 'for a newly created escort' do
      let(:escort) { create(:escort) }
      specify { expect(escort).not_to be_issued }
    end

    context 'when the escort has been issued' do
      let(:escort) { create(:escort, issued_at: 1.day.ago) }
      specify { expect(escort).to be_issued }
    end
  end

  describe '#issue!' do
    let(:escort) { create(:escort) }

    context 'when the escort is already issued' do
      let(:issued_date) { 3.days.ago }
      let(:escort) { create(:escort, issued_at: issued_date) }

      it 'raises an AlreadyIssuedError' do
        expect { escort.issue! }.to raise_error(Escort::AlreadyIssuedError)
      end

      it 'keeps the current issued date' do
        expect { escort.issue! rescue nil }
          .not_to change { escort.reload.issued_at.to_i }.from(issued_date.to_i)
      end
    end

    context 'when the escort is not issued yet' do
      let(:escort) { create(:escort) }

      it 'marks the escort as issued' do
        time = Time.now.utc
        expect { escort.issue! }
          .to change { escort.reload.issued_at }.from(nil)
        expect(escort.issued_at).to be >= time
      end
    end
  end

  describe '#needs_review!' do
    context 'when is already in review' do
      let(:escort) { create(:escort, :needs_review) }

      it 'leaves the escort as needing reviewing' do
        expect { escort.needs_review! }
          .not_to change { escort.reload.needs_review? }.from(true)
      end
    end

    context 'when is not in review' do
      let(:escort) { create(:escort, :completed) }

      it 'marks the escort as needs reviewing' do
        expect { escort.needs_review! }
          .to change { escort.reload.needs_review? }.from(false).to(true)
      end
    end
  end

  describe '#needs_review?' do
    let(:detainee) { create(:detainee) }
    let(:risk) { create(:risk) }
    let(:healthcare) { create(:healthcare) }
    let(:offences_workflow) { create(:offences_workflow) }
    let(:escort) { create(:escort, detainee: detainee, risk: risk, healthcare: healthcare, offences_workflow: offences_workflow) }

    specify { expect(escort.needs_review?).to be_falsey }

    context 'when risk assessment needs reviewing' do
      let(:risk) { create(:risk, :needs_review) }

      specify { expect(escort.needs_review?).to be_truthy }
    end

    context 'when healthcare assessment needs reviewing' do
      let(:healthcare) { create(:healthcare, :needs_review) }

      specify { expect(escort.needs_review?).to be_truthy }
    end

    context 'when offences needs reviewing' do
      let(:offences_workflow) { create(:offences_workflow, :needs_review) }

      specify { expect(escort.needs_review?).to be_truthy }
    end
  end

  describe '#from_prison?' do
    let(:move) { create(:move, from_establishment: establishment) }
    let(:escort) { create(:escort, move: move)}

    context 'when created in prison' do
      let(:establishment) { create(:prison) }

      specify { expect(escort.from_prison?).to be_truthy }
    end

    context 'when not created in prison' do
      let(:establishment) { create(:police_custody) }

      specify { expect(escort.from_prison?).to be_falsey }
    end
  end

  describe '#from_police?' do
    let(:move) { create(:move, from_establishment: establishment) }
    let(:escort) { create(:escort, move: move)}

    context 'when created in police custody' do
      let(:establishment) { create(:police_custody) }

      specify { expect(escort.from_police?).to be_truthy }
    end

    context 'when not created in police custody' do
      let(:establishment) { create(:prison) }

      specify { expect(escort.from_police?).to be_falsey }
    end
  end

  describe '#number' do
    let(:move) { create(:move, from_establishment: establishment) }
    let(:escort) { create(:escort, :with_detainee, move: move)}

    context 'when created in prison' do
      let(:establishment) { create(:prison) }

      specify { expect(escort.number).to eq escort.prison_number }
    end

    context 'when created in police custody' do
      let(:establishment) { create(:police_custody) }

      specify { expect(escort.number).to eq escort.pnc_number }
    end
  end

  describe '#non_applicable_alerts' do
    subject { escort.non_applicable_alerts }

    let(:move) { create(:move, from_establishment: establishment) }
    let(:escort) { create(:escort, detainee: detainee , move: move)}
    let(:detainee) { create(:detainee, gender: gender) }

    context 'detainee male' do
      let(:gender) { 'male' }

      context 'prison escort' do
        let(:establishment) { create(:prison) }

        specify {
          expect(subject).to eq %i[pregnant alcohol_withdrawal]
        }
      end

      context 'police escort' do
        let(:establishment) { create(:police_custody) }

        specify {
          expect(subject).to eq %i[pregnant acct_status rule_45 category_a]
        }
      end
    end

    context 'detainee female' do
      let(:gender) { 'female' }

      context 'prison escort' do
        let(:establishment) { create(:prison) }

        specify {
          expect(subject).to eq %i[pregnant alcohol_withdrawal]
        }
      end

      context 'police escort' do
        let(:establishment) { create(:police_custody) }

        specify {
          expect(subject).to eq %i[acct_status rule_45 category_a]
        }
      end
    end
  end
end
