require 'nomis/models/details'

RSpec.describe Nomis::Details do
  subject { described_class.new }

  describe 'model defaults values' do
    %i[ birth_date nationalities sex cro_number
        pnc_number working_name agency_location ].each do |a|
      it("#{a} returns nil") { expect(subject.public_send(a)).to be_nil }
    end
  end

  describe '#birth_date' do
    it 'coerces & returns an instance of a date' do
      subject.birth_date = '1970-01-01'
      expect(subject.birth_date).to eq Date.civil(1970, 1, 1)
    end
  end

  describe '#working_name' do
    it 'coerces & returns a boolean' do
      subject.working_name = 'Y'
      expect(subject.working_name).to be true
      subject.working_name = 'N'
      expect(subject.working_name).to be false
    end
  end

  describe '#current?' do
    it 'is an alias to working_name' do
      subject.working_name = 'Y'
      expect(subject).to be_current
      subject.working_name = 'N'
      expect(subject).not_to be_current
    end
  end

  describe '#forenames' do
    it 'humanizes & strips whitespace from the string' do
      subject.forenames = ' BEAVIS '
      expect(subject.forenames).to eq 'Beavis'
    end
  end

  describe '#surname' do
    it 'humanizes & strips whitespace from the string' do
      subject.forenames = ' Butthead '
      expect(subject.forenames).to eq 'Butthead'
    end
  end

  def nationalities
    it 'returns a list of nationalities as a sentence' do
      subject.nationalities = [{nationality: 'British'}]
      expect(subject.nationalities).to eq 'British'
      subject.nationalities = Array.new(3) { {nationality: 'British'} }
      expect(subject.nationalities).to eq 'British, British and British'
    end
  end

  def sex
    it 'translates "M" to male' do
      subject.sex = 'M'
      expect(subject.sex).to eq 'male'
    end

    it 'translates "F" to female' do
      subject.sex = 'F'
      expect(subject.sex).to eq 'female'
    end
  end
end
