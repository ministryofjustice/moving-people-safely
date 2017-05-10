require 'feature_helper'

RSpec.feature 'printing a PER', type: :feature do
  let(:escort) { create(:escort, detainee: detainee, move: move) }
  let(:move) {
    create(
      :move,
      :confirmed,
      from: 'HMP Bedford',
      to: 'Luton Crown Court',
      date: Date.civil(2099, 4, 22),
      destinations: destinations
    )
  }

  let(:offences) { [] }

  let(:detainee) {
    create(
      :detainee,
      prison_number: 'W1234BY',
      forenames: 'Testy',
      surname: 'McTest',
      date_of_birth: Date.civil(1970, 12, 10),
      aliases: 'Terry Tibbs, Mr T',
      gender: 'male',
      nationalities: 'British',
      cro_number: '56TYY/UU',
      pnc_number: 'YI896668TT',
      risk: risk,
      healthcare: healthcare,
      offences: offences
    )
  }

  context 'when a PER is completed with all answers as no' do
    let(:destinations) { [] }
    let(:risk) {
      create(:risk, {
        acct_status: 'none',
        rule_45: 'no',
        csra: 'standard',
        victim_of_abuse: 'no',
        high_profile: 'no',
        risk_to_females: 'no',
        homophobic: 'no',
        racist: 'no',
        discrimination_to_other_religions: 'no',
        other_violence_due_to_discrimination: 'no',
        violence_to_staff: 'no',
        violence_to_other_detainees: 'no',
        violence_to_general_public: 'no',
        hostage_taker: 'no',
        intimidation: 'no',
        sex_offence: 'no',
        current_e_risk: 'no',
        previous_escape_attempts: 'no',
        category_a: 'no',
        escape_pack: 'no',
        escort_risk_assessment: 'no',
        substance_supply: 'no',
        conceals_weapons: 'no',
        conceals_drugs: 'no',
        conceals_mobile_phone_or_other_items: 'no',
        uses_weapons: 'no',
        arson: 'no',
        other_risk: 'no'
      })
    }
    let(:healthcare) {
      create(:healthcare, {
        physical_issues: 'no',
        mental_illness: 'no',
        phobias: 'no',
        personal_hygiene: 'no',
        personal_care: 'no',
        allergies: 'no',
        dependencies: 'no',
        has_medications: 'no',
        mpv: 'no',
        hearing_speech_sight_issues: 'no',
        reading_writing_issues: 'no',
        healthcare_professional: 'John Doctor Doe',
        contact_number: '1-131-999-0232'
      })
    }

    scenario 'user prints the PER' do
      login
      visit escort_path(escort)
      escort_page.click_print

      expect(page.body).
        to validate_as_pdf_that_contains_text('pdf-text-all-no-answers.txt')
    end
  end

  context 'when a PER has detailed answers' do
    let(:offences) {
      [
      create(:offence, offence: 'Burglary', case_reference: 'LXAHTGNJQF'),
      create(:offence, offence: 'Sex offence', case_reference: 'QDPREIBMSF')
      ]
    }
    let(:must_return_destination) { create(:destination, :must_return, establishment: 'HMP Brixton', reasons: 'Its a lovely place.') }
    let(:must_not_return_destination) { create(:destination, :must_not_return, establishment: 'HMP Clive House', reasons: 'Its too cold.') }
    let(:destinations) { [must_return_destination, must_not_return_destination] }
    let(:risk) {
      create(:risk, {
          acct_status: 'open',
          rule_45: 'yes',
          csra: 'high',
          victim_of_abuse: 'yes',
          victim_of_abuse_details: 'abuse details',
          high_profile: 'yes',
          high_profile_details: 'high profile details',
          risk_to_females: 'yes',
          risk_to_females_details: 'risk to females details',
          homophobic: 'yes',
          homophobic_details: 'LGTB details',
          racist: 'yes',
          racist_details: 'violence racist details',
          discrimination_to_other_religions: 'yes',
          discrimination_to_other_religions_details: 'discrimination to other religion details',
          other_violence_due_to_discrimination: 'yes',
          other_violence_due_to_discrimination_details: 'other violence due to discrimination details',
          violence_to_staff: 'yes',
          violence_to_staff_custody: true,
          violence_to_staff_community: true,
          violence_to_other_detainees: 'yes',
          co_defendant: true,
          co_defendant_details: 'violente co-defendant details',
          gang_member: true,
          gang_member_details: 'violence gang member details',
          other_violence_to_other_detainees: true,
          other_violence_to_other_detainees_details: 'other violence to other detainees details',
          violence_to_general_public: 'yes',
          violence_to_general_public_details: 'violence to general public details',
          controlled_unlock_required: 'yes',
          controlled_unlock: 'more_than_four',
          controlled_unlock_details: 'many people to hold the prisoner',
          hostage_taker: 'yes',
          staff_hostage_taker: true,
          date_most_recent_staff_hostage_taker_incident: '12/03/2010',
          prisoners_hostage_taker: true,
          date_most_recent_prisoners_hostage_taker_incident: '24/05/2012',
          public_hostage_taker: true,
          date_most_recent_public_hostage_taker_incident: '02/09/2007',
          intimidation: 'yes',
          intimidation_to_staff: true,
          intimidation_to_staff_details: 'intimidation to staff details',
          intimidation_to_public: true,
          intimidation_to_public_details: 'intimidation to public details',
          intimidation_to_other_detainees: true,
          intimidation_to_other_detainees_details: 'intimidation to other detainees details',
          intimidation_to_witnesses: true,
          intimidation_to_witnesses_details: 'intimidation to witnesses details',
          sex_offence: 'yes',
          sex_offence_adult_male_victim: true,
          sex_offence_adult_female_victim: true,
          sex_offence_under18_victim: true,
          sex_offence_under18_victim_details: 'under 18 sex offence victim details',
          current_e_risk: 'yes',
          current_e_risk_details: 'e_list_escort',
          previous_escape_attempts: 'yes',
          prison_escape_attempt: true,
          prison_escape_attempt_details: 'prison escape attempt details',
          court_escape_attempt: true,
          court_escape_attempt_details: 'court escape attempt details',
          police_escape_attempt: true,
          police_escape_attempt_details: 'police escape attempt details',
          other_type_escape_attempt: true,
          other_type_escape_attempt_details: 'other type of escape attempt details',
          category_a: 'yes',
          escort_risk_assessment: 'yes',
          escort_risk_assessment_completion_date: '26/11/2016',
          escape_pack: 'yes',
          escape_pack_completion_date: '13/12/2016',
          substance_supply: 'yes',
          conceals_weapons: 'yes',
          conceals_weapons_details: 'conceals weapons details',
          conceals_drugs: 'yes',
          conceals_drugs_details: 'conceals drugs details',
          conceals_mobile_phone_or_other_items: 'yes',
          conceals_mobile_phones: true,
          conceals_sim_cards: true,
          conceals_other_items: true,
          conceals_other_items_details: 'conceals other items details',
          uses_weapons: 'yes',
          uses_weapons_details: 'Created and used a 3D gun',
          arson: 'yes',
          other_risk: 'yes',
          other_risk_details: 'suspected terrorist'
        })
      }

    let(:healthcare) {
      create(:healthcare, {
        physical_issues: 'yes',
        physical_issues_details: 'physical issues details',
        mental_illness: 'yes',
        mental_illness_details: 'mental illness details',
        phobias: 'yes',
        phobias_details: 'phobias details',
        personal_hygiene: 'yes',
        personal_hygiene_details: 'personal hygiene details',
        personal_care: 'yes',
        personal_care_details: 'personal care details',
        allergies: 'yes',
        allergies_details: 'allergies details',
        dependencies: 'yes',
        dependencies_details: 'dependencies details',
        has_medications: 'yes',
        mpv: 'yes',
        mpv_details: 'MPV details',
        hearing_speech_sight_issues: 'yes',
        hearing_speech_sight_issues_details: 'hearing/speech/sight issues details',
        reading_writing_issues: 'yes',
        reading_writing_issues_details: 'reading/writing issues details',
        healthcare_professional: 'John Doctor Doe',
        contact_number: '1-131-999-0232'
      })
    }

    scenario 'user prints the PER' do
      login
      visit escort_path(escort)
      escort_page.click_print

      expect(page.body).
        to validate_as_pdf_that_contains_text('pdf-text-all-yes-answers.txt')
    end
  end
end
