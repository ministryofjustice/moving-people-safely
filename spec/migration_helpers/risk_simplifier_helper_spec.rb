require 'rails_helper'
require_relative '../../db/migration_helpers/risk_simplifier_helper'

RSpec.describe RiskSimplifierHelper do
  class TestClass
    include RiskSimplifierHelper
  end

  describe '.simplify_intimidation_attributes' do
    subject { TestClass.new.simplify_intimidation_attributes(risk) }

    let(:risk) do
      double('Risk',
             intimidation: intimidation,
             intimidation_to_other_detainees: to_other_detainees,
             intimidation_to_other_detainees_details: to_other_detainees_details,
             intimidation_to_witnesses: to_witnesses,
             intimidation_to_witnesses_details: to_witnesses_details,
             intimidation_to_public: to_public,
             intimidation_to_public_details: to_public_details
            )
    end

    # Default no intimidation. Override in examples.
    let(:intimidation) { 'no' }
    let(:to_other_detainees) { false }
    let(:to_other_detainees_details) { nil }
    let(:to_witnesses) { false }
    let(:to_witnesses_details) { nil }
    let(:to_public) { false }
    let(:to_public_details) { nil }

    context 'no intimidation' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'intimidates' do
      let(:intimidation) { 'yes' }

      context 'just prisoners' do
        let(:to_other_detainees) { true }
        let(:to_other_detainees_details) { 'Mean to prisoners' }

        it 'just new prisoner intimidation attributes populated' do
          expect(subject).to eq(
            {
              intimidation_prisoners: 'yes',
              intimidation_prisoners_details: to_other_detainees_details,
              intimidation_public: 'no',
              intimidation_public_details: nil
            }
          )
        end
      end

      context 'just witnesses' do
        let(:to_witnesses) { true }
        let(:to_witnesses_details) { 'Mean to witnesses' }

        it 'just new public intimidation attributes populated with witness prefix' do
          expect(subject).to eq(
            {
              intimidation_prisoners: 'no',
              intimidation_prisoners_details: nil,
              intimidation_public: 'yes',
              intimidation_public_details: "Intimidates witnesses: #{to_witnesses_details}"
            }
          )
        end
      end

      context 'just the public' do
        let(:to_public) { true }
        let(:to_public_details) { 'Mean to the public' }

        it 'just new public intimidation attributes populated with public prefix' do
          expect(subject).to eq(
            {
              intimidation_prisoners: 'no',
              intimidation_prisoners_details: nil,
              intimidation_public: 'yes',
              intimidation_public_details: "Intimidates the public: #{to_public_details}"
            }
          )
        end
      end

      context 'witnesses and the public' do
        let(:to_witnesses) { true }
        let(:to_witnesses_details) { 'Mean to witnesses' }
        let(:to_public) { true }
        let(:to_public_details) { 'Mean to the public' }

        it 'just new public intimidation attributes populated with blended details' do
          expect(subject).to eq(
            {
              intimidation_prisoners: 'no',
              intimidation_prisoners_details: nil,
              intimidation_public: 'yes',
              intimidation_public_details: "Intimidates witnesses: #{to_witnesses_details} | Intimidates the public: #{to_public_details}"
            }
          )
        end
      end
    end
  end

  describe '.complexify_intimidation_attributes' do
    subject { TestClass.new.complexify_intimidation_attributes(risk) }

    let(:risk) do
      double('Risk',
             intimidation_prisoners: prisoners,
             intimidation_prisoners_details: prisoners_details,
             intimidation_public: intimidation_public,
             intimidation_public_details: public_details
            )
    end

    # Default no intimidation. Override in examples.
    let(:prisoners) { 'no' }
    let(:prisoners_details) { nil }
    let(:intimidation_public) { 'no' }
    let(:public_details) { nil }

    context 'no intimidation' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'intimidation' do
      context 'just prisoners' do
        let(:prisoners) { 'yes' }
        let(:prisoners_details) { 'Mean to prisoners' }

        it 'Parses details into just other_detainees pair' do
          expect(subject).to eq(
            {
              intimidation: 'yes',
              intimidation_to_other_detainees: true,
              intimidation_to_other_detainees_details: prisoners_details,
              intimidation_to_witnesses: false,
              intimidation_to_witnesses_details: nil,
              intimidation_to_public: false,
              intimidation_to_public_details: nil
            }
          )
        end
      end

      context 'just witnesses' do
        let(:intimidation_public) { 'yes' }
        let(:public_details) { 'Intimidates witnesses: Mean to witnesses' }

        it 'Parses details into just witnesses pair' do
          expect(subject).to eq(
            {
              intimidation: 'yes',
              intimidation_to_other_detainees: false,
              intimidation_to_other_detainees_details: nil,
              intimidation_to_witnesses: true,
              intimidation_to_witnesses_details: 'Mean to witnesses',
              intimidation_to_public: false,
              intimidation_to_public_details: nil
            }
          )
        end
      end

      context 'witnesses and the public' do
        let(:intimidation_public) { 'yes' }
        let(:public_details) do
          'Intimidates witnesses: Mean to witnesses | Intimidates the public: Mean to the public'
        end

        it 'Parses details into separate witness and public pairs' do
          expect(subject).to eq(
            {
              intimidation: 'yes',
              intimidation_to_other_detainees: false,
              intimidation_to_other_detainees_details: nil,
              intimidation_to_witnesses: true,
              intimidation_to_witnesses_details: 'Mean to witnesses',
              intimidation_to_public: true,
              intimidation_to_public_details: 'Mean to the public'
            }
          )
        end
      end
    end
  end

  describe '.simplify_hostage_taker_attributes' do
    subject { TestClass.new.simplify_hostage_taker_attributes(risk) }

    let(:risk) do
      double('Risk',
             hostage_taker: hostage_taker,
             staff_hostage_taker: staff,
             date_most_recent_staff_hostage_taker_incident: date_staff,
             prisoners_hostage_taker: prisoners,
             date_most_recent_prisoners_hostage_taker_incident: date_prisoners,
             public_hostage_taker: public_hostage_taker,
             date_most_recent_public_hostage_taker_incident: date_public
            )
    end

    # Default not hostage taker. Override in examples.
    let(:hostage_taker) { 'no' }
    let(:staff) { false }
    let(:date_staff) { nil }
    let(:prisoners) { false }
    let(:date_prisoners) { nil }
    let(:public_hostage_taker) { false }
    let(:date_public) { nil }

    context 'not hostage taker' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'hostage taker' do
      let(:hostage_taker) { 'yes' }

      context 'just staff' do
        let(:staff) { true }
        let(:date_staff) { '2002/02/03' }

        it 'Details contain just staff info' do
          expect(subject).to eq(
            {
              hostage_taker_details: 'Takes staff hostages. Most recent date: 2002/02/03'
            }
          )
        end
      end

      context 'just prisoners' do
        let(:prisoners) { true }
        let(:date_prisoners) { '2002/02/03' }

        it 'Details contain just prisoners info' do
          expect(subject).to eq(
            {
              hostage_taker_details: 'Takes prisoner hostages. Most recent date: 2002/02/03'
            }
          )
        end
      end

      context 'just public' do
        let(:public_hostage_taker) { true }
        let(:date_public) { '2002/02/03' }

        it 'Details contain just prisoners info' do
          expect(subject).to eq(
            {
              hostage_taker_details: 'Takes public hostages. Most recent date: 2002/02/03'
            }
          )
        end
      end

      context 'combined prisoners & public' do
        let(:prisoners) { true }
        let(:date_prisoners) { '2002/02/03' }
        let(:public_hostage_taker) { true }
        let(:date_public) { '2002/02/04' }

        it 'Details contain just prisoners info' do
          expect(subject).to eq(
            {
              hostage_taker_details: 'Takes prisoner hostages. Most recent date: 2002/02/03 | Takes public hostages. Most recent date: 2002/02/04'
            }
          )
        end
      end
    end
  end

  describe '.complexify_hostage_taker_attributes' do
    subject { TestClass.new.complexify_hostage_taker_attributes(risk) }

    let(:risk) do
      double('Risk', hostage_taker: hostage_taker, hostage_taker_details: details)
    end

    # Default not hostage taker. Override in examples.
    let(:hostage_taker) { 'no' }
    let(:details) { nil }

    context 'not hostage taker' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'hostage_taker' do
      let(:hostage_taker) { 'yes' }

      context 'just staff' do
        let(:details) { 'Takes staff hostages. Most recent date: 01/01/1999' }

        it 'Parses details into just staff pair' do
          expect(subject).to eq(
            {
              staff_hostage_taker: true,
              date_most_recent_staff_hostage_taker_incident: '01/01/1999',
              prisoners_hostage_taker: false,
              date_most_recent_prisoners_hostage_taker_incident: nil,
              public_hostage_taker: false,
              date_most_recent_public_hostage_taker_incident: nil
            }
          )
        end
      end

      context 'just prisoners' do
        let(:details) { 'Takes prisoner hostages. Most recent date: 01/01/1999' }

        it 'Parses details into just prisoner pair' do
          expect(subject).to eq(
            {
              staff_hostage_taker: false,
              date_most_recent_staff_hostage_taker_incident: nil,
              prisoners_hostage_taker: true,
              date_most_recent_prisoners_hostage_taker_incident: '01/01/1999',
              public_hostage_taker: false,
              date_most_recent_public_hostage_taker_incident: nil
            }
          )
        end
      end

      context 'just public' do
        let(:details) { 'Takes public hostages. Most recent date: 01/01/1999' }

        it 'Parses details into just public pair' do
          expect(subject).to eq(
            {
              staff_hostage_taker: false,
              date_most_recent_staff_hostage_taker_incident: nil,
              prisoners_hostage_taker: false,
              date_most_recent_prisoners_hostage_taker_incident: nil,
              public_hostage_taker: true,
              date_most_recent_public_hostage_taker_incident: '01/01/1999'
            }
          )
        end
      end

      context 'prisoners and public' do
        let(:details) { 'Takes prisoner hostages. Most recent date: 01/01/1999 | Takes public hostages: Most recent date: 01/01/1999' }

        it 'Parses details into prisoners and public pair' do
          expect(subject).to eq(
            {
              staff_hostage_taker: false,
              date_most_recent_staff_hostage_taker_incident: nil,
              prisoners_hostage_taker: true,
              date_most_recent_prisoners_hostage_taker_incident: '01/01/1999',
              public_hostage_taker: true,
              date_most_recent_public_hostage_taker_incident: '01/01/1999'
            }
          )
        end
      end
    end
  end

  describe '.simplify_sex_offender_attributes' do
    subject { TestClass.new.simplify_sex_offender_attributes(risk) }

    let(:risk) do
      double('Risk',
             sex_offence: sex_offence,
             sex_offence_adult_male_victim: male,
             sex_offence_adult_female_victim: female,
             sex_offence_under18_victim: under18,
             date_most_recent_sexual_offence: most_recent_date
            )
    end

    # Default not sex offender. Override in examples.
    let(:sex_offence) { 'no' }
    let(:male) { false }
    let(:female) { false }
    let(:under18) { false }
    let(:most_recent_date) { nil }

    context 'not sex offender' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'sex offender' do
      let(:sex_offence) { 'yes' }

      context 'male' do
        let(:male) { true }
        let(:most_recent_date) { '2001/01/02' }

        it 'Details contain just male info' do
          expect(subject).to eq(
            {
              sex_offences_details: 'Sex offences against males. Most recent date: 2001/01/02'
            }
          )
        end
      end

      context 'female' do
        let(:female) { true }
        let(:most_recent_date) { '2001/01/02' }

        it 'Details contain just female info' do
          expect(subject).to eq(
            {
              sex_offences_details: 'Sex offences against females. Most recent date: 2001/01/02'
            }
          )
        end
      end

      context 'under 18' do
        let(:under18) { true }
        let(:most_recent_date) { '2001/01/02' }

        it 'Details contain just under 18 info' do
          expect(subject).to eq(
            {
              sex_offences_details: 'Sex offences against under 18s. Most recent date: 2001/01/02'
            }
          )
        end
      end

      context 'female and under 18' do
        let(:female) { true }
        let(:under18) { true }
        let(:most_recent_date) { '2001/01/02' }

        it 'Details contain both female and under 18s info' do
          expect(subject).to eq(
            {
              sex_offences_details: 'Sex offences against females. Most recent date: 2001/01/02 | Sex offences against under 18s. Most recent date: 2001/01/02'
            }
          )
        end
      end
    end
  end

  describe '.complexify_sex_offender_attributes' do
    subject { TestClass.new.complexify_sex_offender_attributes(risk) }

    let(:risk) do
      double('Risk', sex_offence: sex_offence, sex_offences_details: details)
    end

    # Default not sex offender. Override in examples.
    let(:sex_offence) { 'no' }
    let(:details) { nil }

    context 'not sex offender' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'sex offender' do
      let(:sex_offence) { 'yes' }

      context 'just males' do
        let(:details) { 'Sex offences against males. Most recent date: 23rd Oct 2001' }

        it 'Sets male to true and populates most recent date' do
          expect(subject).to eq(
            {
              sex_offence_adult_male_victim: true,
              sex_offence_adult_female_victim: false,
              sex_offence_under18_victim: false,
              date_most_recent_sexual_offence: '23rd Oct 2001'
            }
          )
        end
      end

      context 'just females' do
        let(:details) { 'Sex offences against females. Most recent date: 23rd Oct 2001' }

        it 'Sets female to true and populates most recent date' do
          expect(subject).to eq(
            {
              sex_offence_adult_male_victim: false,
              sex_offence_adult_female_victim: true,
              sex_offence_under18_victim: false,
              date_most_recent_sexual_offence: '23rd Oct 2001'
            }
          )
        end
      end

      context 'just under 18s' do
        let(:details) { 'Sex offences against under 18s. Most recent date: 23rd Oct 2001' }

        it 'Sets under18 to true and populates most recent date' do
          expect(subject).to eq(
            {
              sex_offence_adult_male_victim: false,
              sex_offence_adult_female_victim: false,
              sex_offence_under18_victim: true,
              date_most_recent_sexual_offence: '23rd Oct 2001'
            }
          )
        end
      end

      context 'femailes and under 18s' do
        let(:details) { 'Sex offences against females. Most recent date: 23rd Oct 2001 | Sex offences against under 18s. Most recent date: 23rd Oct 2001' }

        it 'Sets both femailes and under18 to true and populates most recent date' do
          expect(subject).to eq(
            {
              sex_offence_adult_male_victim: false,
              sex_offence_adult_female_victim: true,
              sex_offence_under18_victim: true,
              date_most_recent_sexual_offence: '23rd Oct 2001'
            }
          )
        end
      end
    end
  end

  describe '.simplify_conceals_mobile_phones' do
    subject { TestClass.new.simplify_conceals_mobile_phones(risk) }

    let(:risk) do
      double('Risk',
             conceals_mobile_phone_or_other_items: conceals,
             conceals_mobile_phones: mobile_phones,
             conceals_sim_cards: sim_cards,
             conceals_other_items: other_items,
             conceals_other_items_details: other_items_details
            )
    end

    # Default not conceals. Override in examples.
    let(:conceals) { 'no' }
    let(:mobile_phones) { false }
    let(:sim_cards) { false }
    let(:other_items) { false }
    let(:other_items_details) { nil }

    context 'does not conceal' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'conceals' do
      let(:conceals) { 'yes' }

      context 'just mobile phones' do
        let(:mobile_phones) { true }

        it 'Parses details' do
          expect(subject).to eq(
            {
              conceals_mobile_phone_or_other_items_details: 'Conceals mobile phones'
            }
          )
        end
      end

      context 'just SIM cards' do
        let(:sim_cards) { true }

        it 'Parses details' do
          expect(subject).to eq(
            {
              conceals_mobile_phone_or_other_items_details: 'Conceals SIM cards'
            }
          )
        end
      end

      context 'just other items' do
        let(:other_items) { true }
        let(:other_items_details) { 'Hid an elephant' }

        it 'Parses details' do
          expect(subject).to eq(
            {
              conceals_mobile_phone_or_other_items_details: 'Conceals other items: Hid an elephant'
            }
          )
        end
      end

      context 'SIM cards & other items' do
        let(:sim_cards) { true }
        let(:other_items) { true }
        let(:other_items_details) { 'Hid an elephant' }

        it 'Parses details' do
          expect(subject).to eq(
            {
              conceals_mobile_phone_or_other_items_details: 'Conceals SIM cards | Conceals other items: Hid an elephant'
            }
          )
        end
      end
    end
  end

  describe '.complexify_conceals_mobile_phones' do
    subject { TestClass.new.complexify_conceals_mobile_phones(risk) }

    let(:risk) do
      double('Risk',
             conceals_mobile_phone_or_other_items: conceals,
             conceals_mobile_phone_or_other_items_details: details
            )
    end

    # Default does not conceal. Override in examples.
    let(:conceals) { 'no' }
    let(:details) { nil }

    context 'no intimidation' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'intimidation' do
      let(:conceals) { 'yes' }

      context 'just mobile phones' do
        let(:details) { 'Conceals mobile phones' }

        it 'Parses details into correct boolean' do
          expect(subject).to eq(
            {
              conceals_mobile_phones: true,
              conceals_sim_cards: false,
              conceals_other_items: false,
              conceals_other_items_details: nil
            }
          )
        end
      end

      context 'just SIM cards' do
        let(:details) { 'Conceals SIM cards' }

        it 'Parses details into correct boolean' do
          expect(subject).to eq(
            {
              conceals_mobile_phones: false,
              conceals_sim_cards: true,
              conceals_other_items: false,
              conceals_other_items_details: nil
            }
          )
        end
      end

      context 'just other items' do
        let(:details) { 'Conceals other items: Hid an aardvark' }

        it 'Parses details into correct boolean and details' do
          expect(subject).to eq(
            {
              conceals_mobile_phones: false,
              conceals_sim_cards: false,
              conceals_other_items: true,
              conceals_other_items_details: 'Hid an aardvark'
            }
          )
        end
      end
    end
  end
end
