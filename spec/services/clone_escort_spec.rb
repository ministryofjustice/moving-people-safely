require 'rails_helper'

RSpec.describe CloneEscort, type: :service do
  describe '.for_reuse' do

    let(:escort) { create :escort, :with_multiples }

    subject { described_class.for_reuse escort }

    it 'clones the entire object graph, replacing status fields' do
      expect_escort_status_to_change
      expect_detainee_to_be_cloned
      expect_move_to_be_cloned_without_a_move_date
      expect_move_destinations_to_be_cloned
      expect_risks_to_be_cloned_with_updated_status
      expect_healthcare_to_be_cloned_with_updated_status
      expect_medications_to_be_cloned
      expect_offences_to_be_cloned_with_updated_status
      expect_past_offences_to_be_cloned
      expect_current_offences_to_be_cloned
    end
  end

  def expect_escort_status_to_change
    expect(subject.workflow_status).not_to eq escort.workflow_status
    expect(subject.workflow_status).to eq 'needs_review'
  end

  def expect_detainee_to_be_cloned
    expected_attributes = cloned_attributes(model: escort.detainee,
      additional_overrides: { 'escort_id' => nil }
    )

    expect(subject.detainee).to have_attributes(expected_attributes)
  end

  def expect_move_to_be_cloned_without_a_move_date
    expected_attributes = cloned_attributes(model: escort.move,
      additional_overrides: { 'date' => nil, 'escort_id' => nil }
    )

    expect(subject.move).to have_attributes(expected_attributes)
  end

  def expect_move_destinations_to_be_cloned
    destinations = subject.move.destinations.map(&:attributes)
    expected_destinations = cloned_collection_attributes(collection: escort.move.destinations,
      additional_overrides: { 'move_id' => nil }
    )

    expect(destinations).to match_array(expected_destinations)
  end

  def expect_risks_to_be_cloned_with_updated_status
    expected_attributes = cloned_attributes(model: escort.risk,
      additional_overrides: { 'escort_id' => nil, 'workflow_status' => 'needs_review' }
    )

    expect(subject.risk).to have_attributes(expected_attributes)
  end

  def expect_healthcare_to_be_cloned_with_updated_status
    expected_attributes = cloned_attributes(model: escort.healthcare,
      additional_overrides: { 'escort_id' => nil, 'workflow_status' => 'needs_review' }
    )

    expect(subject.healthcare).to have_attributes(expected_attributes)
  end

  def expect_medications_to_be_cloned
    medications = subject.healthcare.medications.map(&:attributes)
    expected_medications = cloned_collection_attributes(collection: escort.healthcare.medications,
      additional_overrides: { 'healthcare_id' => nil }
    )

    expect(medications).to match_array(expected_medications)
  end

  def expect_offences_to_be_cloned_with_updated_status
    expected_attributes = cloned_attributes(model: escort.offences,
      additional_overrides: { 'escort_id' => nil, 'workflow_status' => 'needs_review' }
    )

    expect(subject.offences).to have_attributes(expected_attributes)
  end

  def expect_past_offences_to_be_cloned
    past_offences = subject.offences.past_offences.map(&:attributes)
    expected_past_offences = cloned_collection_attributes(collection: escort.offences.past_offences,
      additional_overrides: { 'offences_id' => nil }
    )

    expect(past_offences).to match_array(expected_past_offences)
  end

  def expect_current_offences_to_be_cloned
    current_offences = subject.offences.current_offences.map(&:attributes)
    expected_current_offences = cloned_collection_attributes(collection: escort.offences.current_offences,
      additional_overrides: { 'offences_id' => nil }
    )

    expect(current_offences).to match_array(expected_current_offences)
  end

  let(:uncloneable_attrs) { {'id' => nil, 'created_at' => nil, 'updated_at' => nil} }

  def cloned_attributes(model:, additional_overrides: {})
    model.attributes.merge(uncloneable_attrs).merge(additional_overrides)
  end

  def cloned_collection_attributes(collection:, additional_overrides: {})
    collection.map { |el| cloned_attributes(model: el, additional_overrides: additional_overrides) }
  end
end
