require 'rails_helper'

RSpec.describe CloneEscort, type: :service do
  describe '.for_reuse' do
    let(:escort) { create :escort }
    subject { described_class.for_reuse escort }

    it 'clones the entire object graph, replacing status fields' do
      expect_detainee_to_be_cloned
      expect_move_to_be_cloned_without_a_move_date
      expect_risks_to_be_cloned_with_updated_status
      expect_healthcare_to_be_cloned_with_updated_status
      expect_offences_to_be_cloned_with_updated_status
    end
  end

  def expect_detainee_to_be_cloned
    expected_attributes = escort.detainee.attributes.
      merge('id' => nil, 'escort_id' => nil, 'created_at' => nil, 'updated_at' => nil)

    expect(subject.detainee).to have_attributes(expected_attributes)
  end

  def expect_move_to_be_cloned_without_a_move_date
    expected_attributes = escort.move.attributes.
      merge('date' => nil, 'id' => nil, 'escort_id' => nil, 'created_at' => nil, 'updated_at' => nil)

    expect(subject.move).to have_attributes(expected_attributes)
  end

  def expect_risks_to_be_cloned_with_updated_status
    expected_attributes = escort.risk.attributes.
      merge('id' => nil, 'escort_id' => nil, 'created_at' => nil, 'updated_at' => nil, 'workflow_status' => 'needs_review')

    expect(subject.risk).to have_attributes(expected_attributes)
  end

  def expect_healthcare_to_be_cloned_with_updated_status
    expected_attributes = escort.healthcare.attributes.
      merge('id' => nil, 'escort_id' => nil, 'created_at' => nil, 'updated_at' => nil, 'workflow_status' => 'needs_review')

    expect(subject.healthcare).to have_attributes(expected_attributes)
  end

  def expect_offences_to_be_cloned_with_updated_status
    expected_attributes = escort.offences.attributes.
      merge('id' => nil, 'escort_id' => nil, 'created_at' => nil, 'updated_at' => nil, 'workflow_status' => 'needs_review')

    expect(subject.offences).to have_attributes(expected_attributes)
  end
end
