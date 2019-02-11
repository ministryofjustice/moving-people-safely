require 'rails_helper'

RSpec.describe EscortIssuer do
  subject(:issuer) { described_class.new(escort) }

  describe '#call' do
    context 'when the escort has been issued already' do
      let(:escort) { create(:escort, :issued) }

      it 'raises an EscortNotEditableError' do
        expect { issuer.call }.to raise_error(EscortIssuer::EscortNotEditableError)
      end
    end

    context 'when the escort has been cancelled' do
      let(:escort) { create(:escort, :cancelled) }

      it 'raises an EscortNotEditableError' do
        expect { issuer.call }.to raise_error(EscortIssuer::EscortNotEditableError)
      end
    end

    context 'when the escort is not issued yet' do
      let(:escort) { create(:escort, :completed) }

      it 'generates a PDF and saves it' do
        expect { issuer.call }
          .to change { escort.reload.document.attached? }
          .from(false).to(true)

        expect(escort.document.filename.to_s).to end_with '.pdf'
      end

      it 'marks the escort as issued' do
        expect { issuer.call }
          .to change { escort.reload.issued? }
          .from(false).to(true)
      end

      context 'but the escort is not in a valid state to be issued' do
        let(:escort) { create(:escort, :with_incomplete_risk_assessment) }

        it 'raises an EscortNotReadyForIssueError' do
          expect { issuer.call }.to raise_error(EscortIssuer::EscortNotReadyForIssueError)
        end
      end

      shared_examples_for 'an unsuccessful transaction' do
        it 'does not save the generated PDF' do
          expect { issuer.call rescue nil }
            .not_to change { escort.reload.document.attached? }
            .from(false)
        end

        it 'does not mark the escort as issued' do
          expect { issuer.call rescue nil }
            .not_to change { escort.reload.issued? }
            .from(false)
        end
      end

      context 'when generating the PDF fails' do
        before do
          allow(PdfGenerator).to receive(:new).with(escort).and_raise
        end

        include_examples 'an unsuccessful transaction'
      end

      context 'when marking the escort as issued fails' do
        before do
          expect(escort).to receive(:issue!).and_raise(ActiveRecord::RecordInvalid)
        end

        include_examples 'an unsuccessful transaction'
      end
    end
  end
end
