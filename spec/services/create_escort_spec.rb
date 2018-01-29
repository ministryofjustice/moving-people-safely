require 'rails_helper'

RSpec.describe EscortCreator, type: :service do
  subject { described_class.new(prison_number: prison_number) }

  let(:except_assessment_attributes) do
    %w(id escort_id created_at updated_at status reviewer_id reviewed_at)
  end

  let(:except_current_offences_attributes) do
    %w(id detainee_id created_at updated_at)
  end

  let(:nomis_api_offences) do
    File.read(
      Rails.root.join('spec', 'support', 'fixtures', 'valid-nomis-charges.json')
    )
  end

  let(:expected_nomis_api_offences_attributes) do
    [
      {
        "offence" =>
          "Attempt burglary dwelling with intent to inflict grievous bodily harm",
        "case_reference" => "T20117495"
      },
      {
        "offence" => "Abstract / use without authority electricity",
        "case_reference" => "T20117495"
      }
    ]
  end

  let(:nomis_api_detainee_attributes) do
    {
      given_name: 'Ned',
      middle_names: 'Kryton',
      surname: 'Kelly'
    }
  end

  let(:prison_number)           { 'A1234BC' }
  let(:nomis_api_detainee_path) { "/offenders/#{prison_number}" }
  let(:nomis_api_image_path)    { "#{nomis_api_detainee_path}/image" }
  let(:nomis_api_offences_path) { "#{nomis_api_detainee_path}/charges" }

  shared_context :nomis_up do
    before do
      stub_nomis_api_request(:get, nomis_api_offences_path,
        body: nomis_api_offences)
      stub_nomis_api_request(:get, nomis_api_detainee_path,
        body: nomis_api_detainee_attributes.to_json)
      stub_nomis_api_request(:get, nomis_api_image_path, body: '')
    end

    let!(:escort) { subject.call }
  end

  shared_context :nomis_down do
    before do
      stub_nomis_api_request(:get, nomis_api_offences_path, body: '{}')
      stub_nomis_api_request(:get, nomis_api_detainee_path, body: '{}')
      stub_nomis_api_request(:get, nomis_api_image_path, body: '{}')
    end

    let!(:escort) { subject.call }
  end

  shared_context :nomis_error do
    before do
      stub_nomis_api_request(:get, nomis_api_offences_path, status: 500)
      stub_nomis_api_request(:get, nomis_api_detainee_path, status: 500)
      stub_nomis_api_request(:get, nomis_api_image_path, status: 500)
    end

    let!(:escort) { subject.call }
  end

  let(:expected_nomis_errors) do
    %w[
      alerts.detainee.details.unavailable
      alerts.detainee.image.unavailable
      alerts.offences.api_error
    ]
  end

  shared_examples 'creates new' do
    it 'has a detainee' do
      expect(escort.detainee).not_to be_nil
    end

    it 'has no move' do
      expect(escort.move).to be_nil
    end
  end

  shared_examples 'detainee details from NOMIS' do
    it 'detainee details are populated from NOMIS' do
      expect(escort.detainee.prison_number).to eq(prison_number)
      expect(escort.detainee.forenames).to eq('NED KRYTON')
      expect(escort.detainee.surname).to eq('KELLY')
    end
  end

  shared_examples 'detainee details blank' do
    it 'detainee details are left blank ready to be filled in' do
      expect(escort.detainee.forenames).to be_nil
      expect(escort.detainee.surname).to be_nil
    end
  end

  shared_examples 'expected count' do |expected_count|
    it "there are now #{expected_count} escorts with this prisoner number" do
      expect(Escort.where(prison_number: prison_number).count)
        .to eq(expected_count)
    end
  end

  shared_examples 'creates clone' do
    it 'detainee is cloned' do
      detainee_attributes = existent_escort.detainee.attributes.except(
        *%w(id escort_id created_at updated_at))
      expect(escort.detainee.id).not_to eq(existent_escort.detainee.id)
      expect(escort.detainee).to have_attributes(detainee_attributes)
    end

    it 'risk is cloned' do
      risk_attributes = existent_escort.risk.attributes.except(
        *except_assessment_attributes)
      expect(escort.risk.id).not_to eq(existent_escort.risk.id)
      expect(escort.risk).to have_attributes(risk_attributes)
      expect(escort.risk.status).to eq('needs_review')
    end

    it 'healthcare is cloned' do
      healthcare_attributes = existent_escort.healthcare.attributes.except(
        *except_assessment_attributes)
      expect(escort.healthcare.id).not_to eq(existent_escort.healthcare.id)
      expect(escort.healthcare).to have_attributes(healthcare_attributes)
      expect(escort.healthcare.status).to eq('needs_review')
    end

    it 'move is nil' do
      expect(escort.move).to be_nil
    end

    it 'points to original escort' do
      expect(escort.twig).to eq(existent_escort)
    end
  end

  shared_examples 'offences cloned' do
    it 'offences are cloned' do
      expect(escort.offences_workflow.status).to eq('needs_review')

      expected_offences_attributes = existent_escort.offences.map do |o|
        o.attributes.except(*except_current_offences_attributes)
      end

      offences_attributes = escort.offences.map do |o|
        o.attributes.except(*except_current_offences_attributes)
      end

      expect(offences_attributes).to match_array(expected_offences_attributes)
    end
  end

  shared_examples 'offences refreshed' do
    it 'offences are refreshed from NOMIS' do
      escort_offences_attributes = escort.offences.map do |o|
        o.attributes.except(*except_current_offences_attributes)
      end

      expect(escort_offences_attributes)
        .to match_array(expected_nomis_api_offences_attributes)
    end
  end

  context 'when there no escorts for the given prison number' do
    context 'NOMIS is down' do
      include_context :nomis_down
      it_behaves_like 'creates new'
      it_behaves_like 'detainee details blank'
      it_behaves_like 'expected count', 1
    end

    context 'NOMIS is up' do
      include_context :nomis_up
      it_behaves_like 'creates new'
      it_behaves_like 'detainee details from NOMIS'
      it_behaves_like 'offences refreshed'
      it_behaves_like 'expected count', 1
    end

    context 'NOMIS has an error' do
      include_context :nomis_error
      it_behaves_like 'creates new'
      it_behaves_like 'detainee details blank'
      it_behaves_like 'expected count', 1

      it 'has the expected errors' do
        expect(subject.nomis_errors.sort).to match_array(expected_nomis_errors)
      end
    end
  end

  context 'when there are existing escorts for the given prison number' do
    context 'and escort is not cancelled' do
      let!(:existent_escort) do
        create(:escort, :completed, prison_number: prison_number)
      end

      context 'NOMIS is up' do
        include_context :nomis_up
        it_behaves_like 'creates clone'
        it_behaves_like 'offences refreshed'
        it_behaves_like 'expected count', 2
      end

      context 'NOMIS is down' do
        include_context :nomis_down
        it_behaves_like 'creates clone'
        it_behaves_like 'offences cloned'
        it_behaves_like 'expected count', 2
      end
    end

    context 'and escort is cancelled' do
      let!(:existent_escort) do
        create(:escort, :cancelled, prison_number: prison_number)
      end

      context 'NOMIS is down' do
        include_context :nomis_down
        it_behaves_like 'creates new'
        it_behaves_like 'detainee details blank'
        it_behaves_like 'expected count', 2
      end

      context 'NOMIS is up' do
        include_context :nomis_up
        it_behaves_like 'creates new'
        it_behaves_like 'detainee details from NOMIS'
        it_behaves_like 'expected count', 2
      end
    end

    context 'and an escort is issued and another one is cancelled' do
      let!(:cancelled_escort) do
        create(:escort, :cancelled, prison_number: prison_number)
      end

      let!(:existent_escort) do
        create(:escort, :issued, prison_number: prison_number)
      end

      context 'NOMIS is down' do
        include_context :nomis_down
        it_behaves_like 'creates clone'
        it_behaves_like 'offences cloned'
        it_behaves_like 'expected count', 3
      end

      context 'NOMIS is up' do
        include_context :nomis_up
        it_behaves_like 'creates clone'
        it_behaves_like 'offences refreshed'
        it_behaves_like 'expected count', 3
      end
    end
  end
end
