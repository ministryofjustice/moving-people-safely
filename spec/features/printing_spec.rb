require 'feature_helper'

RSpec.feature 'printing a PER', type: :feature do
  scenario 'user prints a completed PER with all answers as no' do
    risk = create(:risk, {
      acct_status: 'none',
      rule_45: 'no',
      csra: 'standard',
      victim_of_abuse: 'no',
      high_profile: 'no',
      violence_due_to_discrimination: 'no',
      violence_to_staff: 'no',
      violence_to_other_detainees: 'no',
      violence_to_general_public: 'no',
      harassment: 'no',
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
      arson: 'no',
      damage_to_property: 'no'
    })
    healthcare = create(:healthcare, {
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
    detainee = FactoryGirl.create(:detainee, risk: risk, healthcare: healthcare)
    move = FactoryGirl.create(:move, :confirmed, :with_destinations, detainee: detainee)

    login
    visit detainee_path(detainee)
    print_per
    move_print_page.assert_detainee_details(detainee)
    move_print_page.assert_move_details(move)

    within('#risk-table') do
      expect(page).to have_text('Risk to selfNo').
        and have_text("Risk from othersNo").
        and have_text("Risk to others - discriminationNo").
        and have_text("Violent to staffNo").
        and have_text("Violent to other detaineesNo").
        and have_text("Violent to general publicNo").
        and have_text("Risk to others - hostage takerNo").
        and have_text("Risk to others: harasser and/or bullyNo").
        and have_text("Intimidator/bullyNo").
        and have_text("Sex offenderNo").
        and have_text("Escape status/historyNo").
        and have_text("Made previous escape attemptsNo").
        and have_text("Category A or Restricted statusNo").
        and have_text("Escort Risk Assessment/Escort PackNo").
        and have_text("Risk of trafficking drugs or alcoholNo").
        and have_text("Conceals weapons, drugs or other itemsNo").
        and have_text("Arson and damage to propertyNo")

      # asserting the number of rows containing the risk answers
      # with full detailed answers you get more rows than when
      # all answers are no
      expect(page.all('tr').size).to eq(17)
    end

    within('#healthcare-table') do
      expect(page).to have_text('Physical healthcareNo').
        and have_text('Mental healthcareNo').
        and have_text('Social healthcareNo').
        and have_text('AllergiesNo').
        and have_text('Medical health needsNo').
        and have_text('TransportNo').
        and have_text('Communication / language difficultiesNo').
        and have_text('Medical contactYes').
        and have_text('Healthcare professionalJohn doctor doe').
        and have_text('Contact number1-131-999-0232')

      # asserting the number of rows containing the healtcare answers
      # with full detailed answers you get more rows than when
      # all answers are no
      expect(page.all('tr').size).to eq(10)
    end
  end

  scenario 'user prints a completed PER with the most fully detailed answers' do
    risk = create(:risk, {
      acct_status: 'open',
      rule_45: 'yes',
      csra: 'high',
      victim_of_abuse: 'yes',
      victim_of_abuse_details: 'abuse details',
      high_profile: 'yes',
      high_profile_details: 'high profile details',
      violence_due_to_discrimination: 'yes',
      risk_to_females: true,
      homophobic: true,
      racist: true,
      racist_details: 'violence racist details',
      other_violence_due_to_discrimination: true,
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
      hostage_taker: 'yes',
      staff_hostage_taker: true,
      date_most_recent_staff_hostage_taker_incident: '12/03/2010',
      prisoners_hostage_taker: true,
      date_most_recent_prisoners_hostage_taker_incident: '24/05/2012',
      public_hostage_taker: true,
      date_most_recent_public_hostage_taker_incident: '02/09/2007',
      harassment: 'yes',
      harassment_details: 'harassment details',
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
      trafficking_drugs: true,
      trafficking_alcohol: true,
      conceals_weapons: 'yes',
      conceals_weapons_details: 'conceals weapons details',
      conceals_drugs: 'yes',
      conceals_drugs_details: 'conceals drugs details',
      conceals_mobile_phone_or_other_items: 'yes',
      conceals_mobile_phones: true,
      conceals_sim_cards: true,
      conceals_other_items: true,
      conceals_other_items_details: 'conceals other items details',
      arson: 'yes',
      damage_to_property: 'yes'
    })
    healthcare = create(:healthcare, {
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
    detainee = FactoryGirl.create(:detainee, risk: risk, healthcare: healthcare)
    move = create(:move, :confirmed, :with_destinations, detainee: detainee)

    login
    visit detainee_path(detainee)
    print_per
    move_print_page.assert_detainee_details(detainee)
    move_print_page.assert_move_details(move)

    within('#risk-table') do
      expect(page).to have_text('Risk to selfYes').
        and have_text("ACCT statusOpen").
        and have_text("Risk from othersYes").
        and have_text("Rule 45Yes").
        and have_text("CSRAHigh").
        and have_text("Victim of abuse in prisonYesabuse details").
        and have_text("High public interestYeshigh profile details").
        and have_text("Risk to others - discriminationYes").
        and have_text("Risk to femalesYes").
        and have_text("HomosexualsYes").
        and have_text("RacistYesviolence racist details").
        and have_text("OtherYesother violence due to discrimination details").
        and have_text("Violent to staffYes").
        and have_text("Staff custodyYes").
        and have_text("Staff communityYes").
        and have_text("Violent to other detaineesYes").
        and have_text("Co-defendantYesviolente co-defendant details").
        and have_text("Gang memberYesviolence gang member details").
        and have_text("Other known conflictsYesother violence to other detainees details").
        and have_text("Violent to general publicYes").
        and have_text("General publicYes").
        and have_text("Risk to others - hostage takerYes").
        and have_text("StaffYes12/03/2010").
        and have_text("PrisonersYes24/05/2012").
        and have_text("PublicYes02/09/2007").
        and have_text("Risk to others: harasser and/or bullyYes").
        and have_text("HarasserYesharassment details").
        and have_text("Intimidator/bullyYes").
        and have_text("StaffYesintimidation to staff details").
        and have_text("PublicYesintimidation to public details").
        and have_text("PrisonersYesintimidation to other detainees details").
        and have_text("WitnessesYesintimidation to witnesses details").
        and have_text("Sex offenderYes").
        and have_text("Adult maleYes").
        and have_text("Adult femaleYes").
        and have_text("Under 18Yesunder 18 sex offence victim details").
        and have_text("Escape status/historyYes").
        and have_text("Currently on E listYesE-List-Escort").
        and have_text("Made previous escape attemptsYes").
        and have_text("PrisonYesprison escape attempt details").
        and have_text("CourtYescourt escape attempt details").
        and have_text("PoliceYespolice escape attempt details").
        and have_text("OtherYesother type of escape attempt details").
        and have_text("Category A or Restricted statusYes").
        and have_text("Escort Risk Assessment/Escort PackYes").
        and have_text("Escort Risk AssessmentYesCompleted on: 26/11/2016").
        and have_text("Escape PackYesCompleted on: 13/12/2016").
        and have_text("Risk of trafficking drugs or alcoholYes").
        and have_text("DrugsYes").
        and have_text("AlcoholYes").
        and have_text("Conceals weapons, drugs or other itemsYes").
        and have_text("Conceals weaponsYesconceals weapons details").
        and have_text("Conceals drugsYesconceals drugs details").
        and have_text("Conceals mobile phonesYes").
        and have_text("Conceals SIM cardsYes").
        and have_text("Conceals other itemsYesconceals other items details").
        and have_text("Arson and damage to propertyYes").
        and have_text("Arson is a behavioural issueYes").
        and have_text("Damage to propertyYes")

      # asserting the number of rows containing the risk answers
      # with full detailed answers you get more rows than when
      # all answers are no
      expect(page.all('tr').size).to eq(60)
    end

    within('#healthcare-table') do
      expect(page).to have_text('Physical healthcareYes').
        and have_text('Physical health needsYesphysical issues details').
        and have_text('Mental healthcareYes').
        and have_text('Mental health issuesYesmental illness details').
        and have_text('PhobiasYesphobias details').
        and have_text('Social healthcareYes').
        and have_text('Personal hygiene issuesYespersonal hygiene details').
        and have_text('Personal care issuesYespersonal care details').
        and have_text('AllergiesYes').
        and have_text('AllergiesYesallergies details').
        and have_text('Medical health needsYes').
        and have_text('Dependencies / misuseYesdependencies details').
        and have_text('Regular medicationYes').
        and have_text('TransportYes').
        and have_text('MPV requiredYesMPV details').
        and have_text('Communication / language difficultiesYes').
        and have_text('Hearing / speech / sight issuesYeshearing/speech/sight issues details').
        and have_text('Reading / writing issuesYesreading/writing issues details').
        and have_text('Medical contactYes').
        and have_text('Healthcare professionalJohn doctor doe').
        and have_text('Contact number1-131-999-0232')

      # asserting the number of rows containing the healtcare answers
      # with full detailed answers you get more rows than when
      # all answers are no
      expect(page.all('tr').size).to eq(21)
    end
  end

  def print_per
    within(".actions") do
      click_link 'Print'
    end
  end
end
