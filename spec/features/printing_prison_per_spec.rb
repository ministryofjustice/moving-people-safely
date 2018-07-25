require 'feature_helper'

RSpec.feature 'printing a prison PER', type: :feature do
  let(:reviewer) {
    create(:user, first_name: 'Nelle', last_name: 'Bailey')
  }
  let(:bedford) {
    create(:prison, name: 'HMP Bedford', sso_id: 'bedford.prisons.noms.moj', nomis_id: 'BDI')
  }
  let(:escort) {
    create(
      :escort,
      prison_number: 'W1234BY',
      detainee: detainee,
      move: move,
      risk: risk,
      healthcare: healthcare,
      offences: offences,
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

  let(:offences_workflow) {
    create(:offences_workflow,
      status: :confirmed,
      reviewer: reviewer,
      reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
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
      diet: 'Gluten free',
      language: 'English',
      interpreter_required: 'yes',
      interpreter_required_details: 'English-American translator',
      religion: 'Baptist',
      ethnicity: 'European',
      cro_number: '56TYY/UU',
      pnc_number: 'YI896668TT',
      peep: 'yes',
      peep_details: 'Broken leg',
      security_category: 'Cat A'
    )
  }

  context 'when a PER is completed with all answers as no' do
    let(:risk) {
      create(:risk, :confirmed,
        acct_status: 'none',
        reviewer: reviewer,
        reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
      )
    }
    let(:healthcare) {
      create(:healthcare, :confirmed,
        contact_number: '1-131-999-0232',
        reviewer: reviewer,
        reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
      )
    }

    scenario 'user prints the PER' do
      login_options = { sso: { info: { permissions: [{'organisation' => bedford.sso_id}]}} }
      login(nil, login_options)
      visit escort_path(escort)
      escort_page.click_print

      expect(page.body).
        to validate_as_pdf_that_contains_text('prison/pdf-text-all-no-answers.txt')
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
          self_harm: 'yes',
          self_harm_details: 'self harm details',
          rule_45: 'yes',
          csra: 'high',
          high_profile: 'yes',
          high_profile_details: 'high profile details',
          vulnerable_prisoner: 'yes',
          vulnerable_prisoner_details: 'vulnerable prisoner details',
          pnc_warnings: 'yes',
          pnc_warnings_details: 'PNC warning details',
          violent_or_dangerous: 'yes',
          violent_or_dangerous_details: 'violent or dangerous',
          gang_member: 'yes',
          gang_member_details: 'violence gang member details',
          violence_to_staff: 'yes',
          violence_to_staff_details: 'violent to staff details',
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
          controlled_unlock: 'yes',
          controlled_unlock_details: 'many people to hold the prisoner',
          hostage_taker: 'yes',
          hostage_taker_details: 'Takes staff hostages. Most recent: 01/01/1999',
          intimidation_public: 'yes',
          intimidation_public_details: 'intimidation to public details',
          intimidation_prisoners: 'yes',
          intimidation_prisoners_details: 'intimidation to other detainees details',
          sex_offence: 'yes',
          sex_offence_details: 'Mean to people. Last offence: 01/01/2001',
          current_e_risk: 'yes',
          current_e_risk_details: 'E-List escort',
          previous_escape_attempts: 'yes',
          previous_escape_attempts_details: 'escape attempt details',
          escort_risk_assessment: 'yes',
          escape_pack: 'yes',
          substance_supply: 'yes',
          substance_supply_details: 'substance supply details',
          conceals_weapons: 'yes',
          conceals_weapons_details: 'conceals weapons details',
          conceals_drugs: 'yes',
          conceals_drugs_details: 'conceals drugs details',
          conceals_mobile_phone_or_other_items: 'yes',
          conceals_mobile_phone_or_other_items_details: 'conceals other items details',
          uses_weapons: 'yes',
          uses_weapons_details: 'Created and used a 3D gun',
          arson: 'yes',
          must_return: 'yes',
          must_return_to: 'Alcatraz',
          must_return_to_details: 'Some special reason',
          has_must_not_return_details: 'yes',
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
      login_options = { sso: { info: { permissions: [{'organisation' => bedford.sso_id}]}} }
      login(nil, login_options)

      visit escort_path(escort)
      escort_page.click_print

      expect(page.body).
        to validate_as_pdf_that_contains_text('prison/pdf-text-all-yes-answers.txt')
    end
  end
end
