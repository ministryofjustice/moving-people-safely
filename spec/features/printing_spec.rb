require 'feature_helper'

RSpec.feature 'printing a PER', type: :feature do
  let(:reviewer) {
    create(:user, first_name: 'Nelle', last_name: 'Bailey')
  }
  let(:bedford) {
    create(:prison, name: 'HMP Bedford')
  }
  let(:escort) {
    create(
      :escort,
      detainee: detainee,
      move: move,
      risk: risk,
      healthcare: healthcare,
      offences_workflow: offences_workflow
    )
  }
  let(:move) {
    create(
      :move,
      from_establishment: bedford,
      to: 'Luton Crown Court',
      date: Date.civil(2099, 4, 22)
    )
  }

  let(:offences_workflow) { create(:offences_workflow, :confirmed) }

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
      religion: 'Baptist',
      ethnicity: 'European',
      cro_number: '56TYY/UU',
      pnc_number: 'YI896668TT',
      offences: offences
    )
  }

  context 'when a PER is completed with all answers as no' do
    let(:risk) {
      create(:risk,
        :confirmed,
        acct_status: 'none',
        rule_45: 'no',
        csra: 'standard',
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
        must_return: 'no',
        must_not_return: 'no',
        other_risk: 'no',
        reviewer: reviewer,
        reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
      )
    }
    let(:healthcare) {
      create(:healthcare,
        :confirmed,
        physical_issues: 'no',
        mental_illness: 'no',
        personal_care: 'no',
        allergies: 'no',
        dependencies: 'no',
        has_medications: 'no',
        mpv: 'no',
        contact_number: '1-131-999-0232',
        reviewer: reviewer,
        reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
      )
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
    let(:medications) {
      [
      build(:medication, description: 'Xanax', administration: 'every 4 hours', carrier: 'escort'),
      build(:medication, description: 'Paracetamol', administration: '2 days a week', carrier: 'prisoner')
      ]
    }
    let(:must_not_return_details) {
      [
      build(:must_not_return_detail, establishment: 'Alcatraz', establishment_details: 'Bad bad stuff happens there'),
      build(:must_not_return_detail, establishment: 'York Castle Prison', establishment_details: 'Does not like it')
      ]
    }
    let(:risk) {
      create(:risk,
          :confirmed,
          acct_status: 'open',
          rule_45: 'yes',
          csra: 'high',
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
          violence_to_staff_details: 'violent to staff details',
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
          date_most_recent_sexual_offence: '12/10/2008',
          current_e_risk: 'yes',
          current_e_risk_details: 'e_list_escort',
          previous_escape_attempts: 'yes',
          previous_escape_attempts_details: 'escape attempt details',
          category_a: 'yes',
          escort_risk_assessment: 'yes',
          escape_pack: 'yes',
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
          must_return: 'yes',
          must_return_to: 'Alcatraz',
          must_return_to_details: 'Some special reason',
          must_not_return: 'yes',
          must_not_return_details: must_not_return_details,
          other_risk: 'yes',
          other_risk_details: 'suspected terrorist',
          reviewer: reviewer,
          reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
        )
      }

    let(:healthcare) {
      create(:healthcare,
        :confirmed,
        physical_issues: 'yes',
        physical_issues_details: 'physical issues details',
        mental_illness: 'yes',
        mental_illness_details: 'mental illness details',
        personal_care: 'yes',
        personal_care_details: 'personal care details',
        allergies: 'yes',
        allergies_details: 'allergies details',
        dependencies: 'yes',
        dependencies_details: 'dependencies details',
        has_medications: 'yes',
        medications: medications,
        mpv: 'yes',
        mpv_details: 'MPV details',
        contact_number: '1-131-999-0232',
        reviewer: reviewer,
        reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
      )
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
