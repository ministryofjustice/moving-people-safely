require 'rails_helper'

RSpec.describe EscortCreator, type: :service do
  let(:prison_number) { 'A1234BC' }
  let(:pnc_number) { '14/293785A' }

  context 'from prison' do
    context 'when there no escorts for the given prison number' do
      it 'create a new escort' do
        expect(Escort.where(prison_number: prison_number).count).to eq(0)
        escort = described_class.call(prison_number: prison_number)
        expect(Escort.where(prison_number: prison_number).count).to eq(1)
      end
    end

    context 'when there are existing escorts for the given prison number' do
      context 'and escort is not cancelled' do
        let!(:existent_escort) { create(:escort, :completed, prison_number: prison_number) }

        it 'creates a clone of the most recent escort' do
          expect(Escort.where(prison_number: prison_number).count).to eq(1)
          escort = described_class.call(prison_number: prison_number)
          expect(Escort.where(prison_number: prison_number).count).to eq(2)
          expect_escort_to_be_cloned(existent_escort, escort)
          expect_risk_assessment_to_be_cloned(existent_escort, escort)
          expect_healthcare_assessment_to_be_cloned(existent_escort, escort)
          expect_offences_to_be_cloned(existent_escort, escort)
          expect(escort.twig).to eq(existent_escort)
        end
      end

      context 'and escort is cancelled' do
        let!(:existent_escort) { create(:escort, :cancelled, prison_number: prison_number) }

        it 'create a new escort' do
          expect(Escort.where(prison_number: prison_number).count).to eq(1)
          escort = described_class.call(prison_number: prison_number)
          expect(Escort.where(prison_number: prison_number).count).to eq(2)
        end
      end

      context 'and an escort is issued and another one is cancelled' do
        let!(:cancelled_escort) { create(:escort, :cancelled, prison_number: prison_number) }
        let!(:issued_escort) { create(:escort, :issued, prison_number: prison_number) }

        it 'creates a clone of the issued escort' do
          expect(Escort.where(prison_number: prison_number).count).to eq(2)
          escort = described_class.call(prison_number: prison_number)
          expect(Escort.where(prison_number: prison_number).count).to eq(3)
          expect_escort_to_be_cloned(issued_escort, escort)
          expect_risk_assessment_to_be_cloned(issued_escort, escort)
          expect_healthcare_assessment_to_be_cloned(issued_escort, escort)
          expect_offences_to_be_cloned(issued_escort, escort)
          expect(escort.twig).to eq(issued_escort)
        end
      end
    end
  end

  context 'from police' do
    let!(:police_custody) { create(:police_custody, name: 'Banbury Police Station') }

    context 'when there no escorts for the given prison number' do
      it 'create a new escort' do
        expect(Escort.where(pnc_number: pnc_number).count).to eq(0)
        escort = described_class.call(pnc_number: pnc_number)
        expect(Escort.where(pnc_number: pnc_number).count).to eq(1)
      end
    end

    context 'when there are existing escorts for the given prison number' do
      context 'and escort is not cancelled' do
        let!(:existent_escort) { create(:escort, :completed, pnc_number: pnc_number, from_establishment: police_custody) }

        it 'creates a clone of the most recent escort' do
          expect(Escort.where(pnc_number: pnc_number).count).to eq(1)
          escort = described_class.call(pnc_number: pnc_number)
          expect(Escort.where(pnc_number: pnc_number).count).to eq(2)
          expect_escort_to_be_cloned(existent_escort, escort)
          expect_risk_assessment_to_be_cloned(existent_escort, escort)
          expect_healthcare_assessment_to_be_cloned(existent_escort, escort)
          expect_offences_to_be_cloned(existent_escort, escort)
          expect(escort.twig).to eq(existent_escort)
        end
      end

      context 'and escort is cancelled' do
        let!(:existent_escort) { create(:escort, :cancelled, pnc_number: pnc_number, from_establishment: police_custody) }

        it 'create a new escort' do
          expect(Escort.where(pnc_number: pnc_number).count).to eq(1)
          escort = described_class.call(pnc_number: pnc_number)
          expect(Escort.where(pnc_number: pnc_number).count).to eq(2)
        end
      end

      context 'and an escort is issued and another one is cancelled' do
        let!(:cancelled_escort) { create(:escort, :cancelled, pnc_number: pnc_number, from_establishment: police_custody) }
        let!(:issued_escort) { create(:escort, :issued, pnc_number: pnc_number, from_establishment: police_custody) }

        it 'creates a clone of the issued escort' do
          expect(Escort.where(pnc_number: pnc_number).count).to eq(2)
          escort = described_class.call(pnc_number: pnc_number)
          expect(Escort.where(pnc_number: pnc_number).count).to eq(3)
          expect_escort_to_be_cloned(issued_escort, escort)
          expect_risk_assessment_to_be_cloned(issued_escort, escort)
          expect_healthcare_assessment_to_be_cloned(issued_escort, escort)
          expect_offences_to_be_cloned(issued_escort, escort)
          expect(escort.twig).to eq(issued_escort)
        end
      end
    end
  end

  def expect_escort_to_be_cloned(existent_escort, new_escort)
    escort_attributes = existent_escort.attributes.except(*%w(id cloned_id escort_id created_at updated_at issued_at document_updated_at date to to_type from_establishment_id not_for_release not_for_release_reason not_for_release_reason_details))
    expect(new_escort.id).not_to eq(existent_escort.id)
    expect(new_escort).to have_attributes(escort_attributes)
  end

  def expect_risk_assessment_to_be_cloned(existent_escort, new_escort)
    risk_attributes = existent_escort.risk.attributes.except(*except_assessment_attributes)
    expect(new_escort.risk.id).not_to eq(existent_escort.risk.id)
    expect(new_escort.risk).to have_attributes(risk_attributes)
    expect(new_escort.risk.status).to eq('needs_review')

    expected_must_not_return_details_attributes = existent_escort.risk.must_not_return_details.map { |m| m.attributes.except(*except_must_not_return_detail_attributes) }
    must_not_return_details_attributes = new_escort.risk.must_not_return_details.map { |m| m.attributes.except(*except_must_not_return_detail_attributes) }
    expect(must_not_return_details_attributes).to match_array(expected_must_not_return_details_attributes)
  end

  def expect_healthcare_assessment_to_be_cloned(existent_escort, new_escort)
    healthcare_attributes = existent_escort.healthcare.attributes.except(*except_assessment_attributes)
    expect(new_escort.healthcare.id).not_to eq(existent_escort.healthcare.id)
    expect(new_escort.healthcare).to have_attributes(healthcare_attributes)
    expect(new_escort.healthcare.status).to eq('needs_review')

    expected_medications_attributes = existent_escort.healthcare.medications.map { |m| m.attributes.except(*except_medication_attributes) }
    medications_attributes = new_escort.healthcare.medications.map { |m| m.attributes.except(*except_medication_attributes) }
    expect(medications_attributes).to match_array(expected_medications_attributes)
  end

  def expect_offences_to_be_cloned(existent_escort, new_escort)
    expect(new_escort.offences_workflow.status).to eq('needs_review')

    expected_offences_attributes = existent_escort.offences.map { |o| o.attributes.except(*except_current_offences_attributes) }
    offences_attributes = new_escort.offences.map { |o| o.attributes.except(*except_current_offences_attributes) }
    expect(offences_attributes).to match_array(expected_offences_attributes)
  end

  def except_attributes
    %w(id escort_id created_at updated_at)
  end

  def except_move_attributes
    %w(id escort_id date created_at updated_at)
  end

  def except_assessment_attributes
    %w(id escort_id medications must_not_return_details created_at updated_at status reviewer_id reviewed_at)
  end

  def except_medication_attributes
    %w(id healthcare_id)
  end

  def except_must_not_return_detail_attributes
    %w(id risk_id)
  end

  def except_offences_attributes
    %w(id escort_id created_at updated_at)
  end

  def except_current_offences_attributes
    %w(id escort_id created_at updated_at)
  end
end
