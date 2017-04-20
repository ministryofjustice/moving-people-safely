require 'rails_helper'

RSpec.describe EscortCreator, type: :service do
  let(:prison_number) { 'A1234BC' }

  context 'when there no escorts for the given prison number' do
    it 'create a new escort' do
      expect(Escort.where(prison_number: prison_number).count).to eq(0)
      escort = described_class.call(prison_number: prison_number)
      expect(Escort.where(prison_number: prison_number).count).to eq(1)
      expect(escort.detainee).to be_nil
      expect(escort.move).to be_nil
    end
  end

  context 'when there are existing escorts for the given prison number' do
    let(:risk) { create(:risk) }
    let(:healthcare) { create(:healthcare, :with_medications) }
    let(:offences) { create(:offences) }
    let(:detainee) { create(:detainee, risk: risk, healthcare: healthcare, offences: offences) }
    let(:move) { create(:move, :with_destinations, :confirmed) }
    let!(:existent_escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }

    it 'creates a clone of the most recent escort' do
      expect(Escort.where(prison_number: prison_number).count).to eq(1)
      escort = described_class.call(prison_number: prison_number)
      expect(Escort.where(prison_number: prison_number).count).to eq(2)
      expect_detainee_to_be_cloned(existent_escort, escort)
      expect_risk_assessment_to_be_cloned(existent_escort, escort)
      expect_healthcare_assessment_to_be_cloned(existent_escort, escort)
      expect_offences_to_be_cloned(existent_escort, escort)
      expect_moves_to_be_cloned(existent_escort, escort)
    end
  end

  def expect_detainee_to_be_cloned(existent_escort, new_escort)
    detainee_attributes = existent_escort.detainee.attributes.except(*%w(id escort_id created_at updated_at))
    expect(new_escort.detainee.id).not_to eq(existent_escort.detainee.id)
    expect(new_escort.detainee).to have_attributes(detainee_attributes)
  end

  def expect_risk_assessment_to_be_cloned(existent_escort, new_escort)
    risk_attributes = existent_escort.risk.attributes.except(*except_assessment_attributes)
    expect(new_escort.risk.id).not_to eq(existent_escort.risk.id)
    expect(new_escort.risk).to have_attributes(risk_attributes)
    expect(new_escort.risk.status).to eq('needs_review')
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
    offences_attributes = existent_escort.offences.attributes.except(*except_offences_attributes)
    expect(new_escort.offences.id).not_to eq(existent_escort.offences.id)
    expect(new_escort.offences).to have_attributes(offences_attributes)
    expect(new_escort.offences.status).to eq('needs_review')

    expected_current_offences_attributes = existent_escort.offences.current_offences.map { |co| co.attributes.except(*except_current_offences_attributes) }
    current_offences_attributes = new_escort.offences.current_offences.map { |co| co.attributes.except(*except_current_offences_attributes) }
    expect(current_offences_attributes).to match_array(expected_current_offences_attributes)
  end

  def expect_moves_to_be_cloned(existent_escort, new_escort)
    move_attributes = existent_escort.move.attributes.except(*except_move_attributes)
    expect(new_escort.move.id).not_to eq(existent_escort.offences.id)
    expect(new_escort.move.date).to be_nil
    expect(new_escort.move).to have_attributes(move_attributes)
    expect(new_escort.move.status).to eq('not_started')

    expected_destinations_attributes = existent_escort.move.destinations.map { |d| d.attributes.except(*except_destinations_attributes) }
    destinations_attributes = new_escort.move.destinations.map { |d| d.attributes.except(*except_destinations_attributes) }
    expect(destinations_attributes).to match_array(expected_destinations_attributes)
  end

  def except_attributes
    %w(id escort_id created_at updated_at)
  end

  def except_move_attributes
    %w(id escort_id date created_at updated_at)
  end

  def except_assessment_attributes
    %w(id detainee_id created_at updated_at)
  end

  def except_medication_attributes
    %w(id healthcare_id created_at updated_at)
  end

  def except_offences_attributes
    %w(id detainee_id created_at updated_at)
  end

  def except_current_offences_attributes
    %w(id offences_id created_at updated_at)
  end

  def except_destinations_attributes
    %w(id move_id created_at updated_at)
  end
end
