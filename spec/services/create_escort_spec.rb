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
    let!(:existent_escort) { create(:escort, :completed, prison_number: prison_number) }

    it 'creates a clone of the most recent escort' do
      expect(Escort.where(prison_number: prison_number).count).to eq(1)
      escort = described_class.call(prison_number: prison_number)
      expect(Escort.where(prison_number: prison_number).count).to eq(2)
      expect_detainee_to_be_cloned(existent_escort, escort)
      expect_risk_assessment_to_be_cloned(existent_escort, escort)
      expect_healthcare_assessment_to_be_cloned(existent_escort, escort)
      expect_offences_to_be_cloned(existent_escort, escort)
      expect(escort.move).to be_nil
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
  end

  def expect_offences_to_be_cloned(existent_escort, new_escort)
    expect(new_escort.offences.status).to eq('needs_review')

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
    %w(id escort_id created_at updated_at status)
  end

  def except_offences_attributes
    %w(id detainee_id created_at updated_at)
  end

  def except_current_offences_attributes
    %w(id detainee_id created_at updated_at)
  end
end
