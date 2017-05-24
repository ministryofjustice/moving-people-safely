require 'rails_helper'

RSpec.describe Escort do
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

  it { is_expected.to delegate_method(:offences).to(:detainee) }

  describe '#completed?' do
    let(:risk) { create(:risk) }
    let(:healthcare) { create(:healthcare) }
    let(:offences_workflow) { create(:offences_workflow) }
    let(:detainee) { create(:detainee, offences_workflow: offences_workflow) }
    let(:move) { create(:move) }
    let(:escort) { create(:escort, detainee: detainee, move: move, risk: risk, healthcare: healthcare) }

    it 'returns true' do
      escort = create(:escort, :completed)
      expect(escort.completed?).to be_truthy
    end

    context 'when detainee info is not complete' do
      let(:detainee) { create(:detainee, surname: nil) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end

    context 'when move info is not complete' do
      let(:move) { create(:move, date: nil) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end

    context 'when risk assessment is not complete' do
      let(:risk) { create(:risk, :incomplete) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end

    context 'when healthcare assessment is not complete' do
      let(:healthcare) { create(:healthcare, :incomplete) }

      it 'returns false' do
        expect(escort.completed?).to be_falsey
      end
    end

    context 'when offences info is not complete' do
      let(:offences_workflow) { create(:offences_workflow) }

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
    let(:offences_workflow) { create(:offences_workflow) }
    let(:detainee) { create(:detainee, offences_workflow: offences_workflow) }
    let(:risk) { create(:risk) }
    let(:healthcare) { create(:healthcare) }
    let(:escort) { create(:escort, detainee: detainee, risk: risk, healthcare: healthcare) }

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

  describe '#current_establishment' do
    subject(:escort) { described_class.new }

    it 'returns the current establishment the prisoner is at' do
      expect(escort.current_establishment).to be_instance_of(Establishment)
    end
  end
end
