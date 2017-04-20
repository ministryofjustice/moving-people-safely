require 'rails_helper'

RSpec.describe Escort do
  describe '#risk' do
    context 'when there is no associated detainee' do
      let(:escort) { create(:escort) }
      specify { expect(escort.risk).to be_nil }
    end

    context 'when there is an associated detainee' do
      let(:detainee) { create(:detainee) }
      let(:escort) { create(:escort, detainee: detainee) }
      specify { expect(escort.risk).to eq(detainee.risk) }
    end
  end

  describe '#healthcare' do
    context 'when there is no associated detainee' do
      let(:escort) { create(:escort) }
      specify { expect(escort.healthcare).to be_nil }
    end

    context 'when there is an associated detainee' do
      let(:detainee) { create(:detainee) }
      let(:escort) { create(:escort, detainee: detainee) }
      specify { expect(escort.healthcare).to eq(detainee.healthcare) }
    end
  end

  describe '#offences' do
    context 'when there is no associated detainee' do
      let(:escort) { create(:escort) }
      specify { expect(escort.offences).to be_nil }
    end

    context 'when there is an associated detainee' do
      let(:detainee) { create(:detainee) }
      let(:escort) { create(:escort, detainee: detainee) }
      specify { expect(escort.offences).to eq(detainee.offences) }
    end
  end

  describe '#completed?' do
    let(:risk) { create(:risk) }
    let(:healthcare) { create(:healthcare) }
    let(:detainee) { create(:detainee, risk: risk, healthcare: healthcare) }
    let(:move) { create(:move, :confirmed) }
    let(:escort) { create(:escort, detainee: detainee, move: move) }

    it 'returns true' do
      expect(escort.completed?).to be_truthy
    end

    context 'when detainee info is not complete' do
      let(:detainee) { create(:detainee, surname: nil) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end

    context 'when move info is not complete' do
      let(:move) { create(:move, :confirmed, date: nil) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end

    context 'when risk assessment is not complete' do
      let(:move_traits) {
        %i[with_incomplete_risk_workflow with_complete_healthcare_workflow with_complete_offences_workflow]
      }
      let(:move) { create(:move, *move_traits) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end

    context 'when healthcare assessment is not complete' do
      let(:move_traits) {
        %i[with_complete_risk_workflow with_incomplete_healthcare_workflow with_complete_offences_workflow]
      }
      let(:move) { create(:move, *move_traits) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end

    context 'when offences info is not complete' do
      let(:move_traits) {
        %i[with_complete_risk_workflow with_complete_healthcare_workflow with_incomplete_offences_workflow]
      }
      let(:move) { create(:move, *move_traits) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end
  end

  describe '#issued?' do
    let(:escort) { create(:escort) }

    context 'when there is not yet a move' do
      it 'returns false' do
        expect(escort.issued?).to be_falsey
      end
    end

    context 'when there is an associated move but has not been issued yet' do
      let(:move) { create(:move) }
      let(:escort) { create(:escort, move: move) }

      it 'returns false' do
        expect(escort.issued?).to be_falsey
      end
    end

    context 'when there is an associated issued move' do
      let(:move) { create(:move, :issued) }
      let(:escort) { create(:escort, move: move) }

      it 'returns true' do
        expect(escort.issued?).to be_truthy
      end
    end
  end

  describe '#issue!' do
    let(:escort) { create(:escort) }

    context 'when there is not yet a move' do
      it 'raises an exception' do
        expect { escort.issue! }
          .to raise_error(NoMethodError)
      end
    end

    context 'when there is an associated move and it is already issued' do
      let(:move) { create(:move, :issued) }
      let(:escort) { create(:escort, move: move) }

      it 'leaves the escort as issued' do
        expect { escort.issue! }
          .not_to change { escort.reload.issued? }.from(true)
      end
    end

    context 'when there is an associated move but it is not issued yet' do
      let(:move) { create(:move) }
      let(:escort) { create(:escort, move: move) }

      it 'marks the escort as issued' do
        expect { escort.issue! }
          .to change { escort.reload.issued? }.from(false).to(true)
      end
    end
  end

  describe '#needs_review!' do
    let(:escort) { create(:escort) }

    context 'when there is not yet an associated move' do
      it 'raises an exception' do
        expect { escort.needs_review! }
          .to raise_error(NoMethodError)
      end
    end

    context 'when there is an associated move and it is already in review' do
      let(:detainee) { create(:detainee) }
      let(:move) { create(:move, :needs_review) }
      let(:escort) { create(:escort, detainee: detainee, move: move) }

      it 'leaves the escort as needing reviewing' do
        expect { escort.needs_review! }
          .not_to change { escort.reload.needs_review? }.from(true)
      end
    end

    context 'when there is an associated move but it is not issued yet' do
      let(:detainee) { create(:detainee) }
      let(:move) { create(:move) }
      let(:escort) { create(:escort, detainee: detainee, move: move) }

      it 'marks the escort as needs reviewing' do
        expect { escort.needs_review! }
          .to change { escort.reload.needs_review? }.from(false).to(true)
      end
    end
  end

  describe '#needs_review?' do
    let(:risk_workflow) { create(:risk_workflow) }
    let(:healthcare_workflow) { create(:healthcare_workflow) }
    let(:offences_workflow) { create(:offences_workflow) }
    let(:workflows) {
      {
        risk_workflow: risk_workflow,
        healthcare_workflow: healthcare_workflow,
        offences_workflow: offences_workflow
      }
    }
    let(:move) { create(:move, workflows) }
    let(:detainee) { create(:detainee) }
    let(:escort) { create(:escort, detainee: detainee, move: move) }

    specify { expect(escort.needs_review?).to be_falsey }

    context 'when risk assessment needs reviewing' do
      let(:risk_workflow) { create(:risk_workflow, :needs_review) }

      specify { expect(escort.needs_review?).to be_truthy }
    end

    context 'when healthcare assessment needs reviewing' do
      let(:healthcare_workflow) { create(:healthcare_workflow, :needs_review) }

      specify { expect(escort.needs_review?).to be_truthy }
    end

    context 'when offences needs reviewing' do
      let(:offences_workflow) { create(:offences_workflow, :needs_review) }

      specify { expect(escort.needs_review?).to be_truthy }
    end
  end
end
