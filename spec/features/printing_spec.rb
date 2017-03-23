require 'feature_helper'

RSpec.feature 'printing a PER', type: :feature do
  let!(:move) { create(:move, :confirmed, destinations: destinations, detainee: detainee) }
  let(:offences) { create(:offences, :with_no_current_offences, :with_no_past_offences) }
  let(:detainee) { create(:detainee, forenames: 'Testy', surname: 'McTest', risk: risk, healthcare: healthcare, offences: offences) }

  let(:outbound_vehicle_details) {
    [
      "Outbound vehicle",
      "Registration Cell number PECS Barcode",
    ]
  }

  let(:return_vehicle_details) {
    [
      "Return vehicle",
      "Registration Cell number",
    ]
  }

  let(:detainee_info_line) {
    "#{detainee.prison_number}: #{detainee.surname} #{detainee.forenames}"
  }

  let(:detainee_details) {
    [
      "Prison number CRO number PNC number Aliases",
      "#{detainee.prison_number} #{detainee.cro_number} #{detainee.pnc_number} #{detainee.aliases}",
      "Date of birth Age GenderNationality",
      "#{detainee.date_of_birth.strftime('%d %b %Y')} #{AgeCalculator.age(detainee.date_of_birth)} #{detainee.gender[0].upcase} #{detainee.nationalities} Photo",
      "unavailable",
    ]
  }

  let(:move_details) {
    [
      "Move details",
      "Date of travel From To",
      "#{move.date.strftime('%d %b %Y')} #{move.from} #{move.to}",
    ]
  }

  let(:person_escort_record_info_panel) {
    [
      "About this Person Escort Record",
      "This person escort record was printed from the Moving People Safely web site.",
      "To find out more about the Person Escort Record go to exmaple.com",
      "If you have feedback or suggestions please email feedback@example.com#{detainee_info_line}",
    ]
  }

  let(:expected_lines) {
    [
      outbound_vehicle_details,
      return_vehicle_details,
      detainee_info_line,
      front_cover_alerts,
      detainee_details,
      move_details,
      person_escort_record_info_panel,
      alerts,
      risk_details,
      healthcare_details,
      offences_details,
      must_return_must_not_return_move_details
    ].flatten
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

    let(:front_cover_alerts){
      [
        "NOT FOR RELEASE E LIST MPV"
      ]
    }

    let(:alerts) {
      [
        "NOT FOR RELEASE ACCT RULE 45",
        "E LIST CSRA STANDARD CAT A MPV"
      ]
    }

    let(:risk_details) {
      [
        "Risk to self No",
        "Risk from others No",
        "Risk to others - No",
        "discrimination",
        "Violent to staff No",
        "Violent to other detaineesNo",
        "Violent to general public No",
        "Risk to others - hostage No",
        "taker",
        "Risk to others: harasser No",
        "and/or bully",
        "Intimidator/bully No",
        "Sex offender No",
        "Escape status/history No",
        "Made previous escape No",
        "attempts",
        "Category A or Restricted No",
        "status",
        "Escort Risk No",
        "Assessment/Escape Pack",
        "Risk of trafficking drugs No",
        "alcohol",
        "Conceals weapons, drugs or No",
        "other items",
        "Arson and damage to No",
        "property"
      ]
    }

    let(:healthcare_details) {
      [
        "Physical healthcare No",
        "Mental healthcare No",
        "Social healthcare No",
        "Allergies No",
        "Medical health needs No",
        "Transport NoCommunication / language No",
        "difficulties",
        "Medical contact Yes",
        "Healthcare professional John doctor doe",
        "Contact number 1-131-999-0232",
      ]
    }

    let(:offences_details) {
      [
        "Current offences None",
        "Significant past offences None"
      ]
    }

    let(:must_return_must_not_return_move_details) {
      [
        "Must return to None",
        "Must NOT return to None"
      ]
    }

    scenario 'user prints the PER' do
      login
      visit detainee_path(detainee)
      profile.click_print

      pdf_text = transform_pdf_to_lines_of_text(page.body).join
      expected_text = expected_lines.join

      expect(pdf_text).to eql expected_text
    end
  end

  context 'when a PER has detailed answers' do
    let(:current_offences) {
      [
      create(:current_offence, offence: 'Burglary', case_reference: 'LXAHTGNJQF'),
      create(:current_offence, offence: 'Sex offence', case_reference: 'QDPREIBMSF')
      ]
    }
    let(:past_offences) {
      [
      create(:past_offence, offence: 'Past Offence 1'),
      create(:past_offence, offence: 'Past Offence 2')
      ]
    }
    let(:offences) { create(:offences, current_offences: current_offences, past_offences: past_offences) }
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

    let(:front_cover_alerts){
      [
        "NOT FOR RELEASE E LIST MPV",
        "E-List-Escort"
      ]
    }

    let(:alerts) {
      [
        "NOT FOR RELEASE ACCT RULE 45",
        "Open",
        "E LIST CSRA HIGH CAT A MPV",
        "E-List-Escort"
      ]
    }

    let(:risk_details) {
      [
        "Risk to self Yes",
        "ACCT status Open",
        "Risk from others Yes",
        "Rule 45 Yes",
        "CSRA (Cell Sharing Risk High",
        "Assessment)",
        "Victim of abuse in prison Yes abuse details",
        "High public interest Yes high profile details",
        "Risk to others - Yes",
        "discrimination",
        "Risk to females Yes",
        "Homosexuals Yes",
        "Racist Yes violence racist details",
        "Other Yes other violence due to discrimination details",
        "Violent to staff Yes",
        "Staff custody Yes",
        "Staff community Yes",
        "Violent to other detainees Yes",
        "Co-defendant Yes violente co-defendant details",
        "Gang member Yes violence gang member details",
        "Other known conflicts Yes other violence to other detainees details",
        "Violent to general public Yes",
        "General public Yes violence to general public details",
        "Risk to others - hostage Yes",
        "taker",
        "Staff Yes 12/03/2010",
        "Prisoners Yes 24/05/2012",
        "Public Yes 02/09/2007Risk to others: harasser Yes",
        "and/or bully",
        "Harasser Yes harassment details",
        "Intimidator/bully Yes",
        "Staff Yes intimidation to staff details",
        "Public Yes intimidation to public details",
        "Prisoners Yes intimidation to other detainees details",
        "Witnesses Yes intimidation to witnesses details",
        "Sex offender Yes",
        "Adult male Yes",
        "Adult female Yes",
        "Under 18 Yes under 18 sex offence victim details",
        "Escape status/history Yes",
        "Currently on E list Yes E-List-Escort",
        "Made previous escape Yes",
        "attempts",
        "Prison Yes prison escape attempt details",
        "Court Yes court escape attempt details",
        "Police Yes police escape attempt details",
        "Other Yes other type of escape attempt details",
        "Category A or Restricted Yes",
        "status",
        "Category A Yes",
        "Escort Risk Yes",
        "Assessment/Escape Pack",
        "Escort Risk Assessment Yes Completed on: 26/11/2016",
        "Escape Pack Yes Completed on: 13/12/2016",
        "Risk of trafficking drugs Yes",
        "or alcohol",
        "Drugs Yes",
        "Alcohol Yes",
        "Conceals weapons, drugs Yes",
        "or other items",
        "Conceals weapons Yes conceals weapons details",
        "Conceals drugs Yes conceals drugs details",
        "Conceals mobile phones Yes Conceals SIM cards Yes",
        "Conceals other items Yes conceals other items details",
        "Arson and damage to Yes",
        "property",
        "Arson is a behavioural Yes",
        "issue",
        "Damage to property Yes",
      ]
    }

    let(:healthcare_details) {
      [
        "Physical healthcare Yes",
        "Physical health needs Yes physical issues details",
        "Mental healthcare Yes",
        "Mental health issues Yes mental illness details",
        "Phobias Yes phobias details",
        "Social healthcare Yes",
        "Personal hygiene issues Yes personal hygiene details",
        "Personal care issues Yes personal care details",
        "Allergies Yes",
        "Allergies Yes allergies details",
        "Medical health needs Yes",
        "Dependencies / misuse Yes dependencies details",
        "Regular medication Yes",
        "Transport Yes",
        "MPV required Yes MPV details",
        "Communication / Yes",
        "language difficulties",
        "Hearing / speech / sight Yes hearing/speech/sight issues details",
        "issues",
        "Reading / writing issues Yes reading/writing issues details",
        "Medical contact Yes",
        "Healthcare professional John doctor doe",
        "Contact number 1-131-999-0232",
      ]
    }

    let(:offences_details) {
      [
        "Current offences Yes Burglary (LXAHTGNJQF) | Sex offence",
        "(QDPREIBMSF)",
        "Significant past offences Yes Past Offence 1 | Past Offence 2"
      ]
    }

    let(:must_return_must_not_return_move_details) {
      [
        "Must return to HMP Brixton: Its a lovely place.",
        "Must NOT return to HMP Clive House: Its too cold."
      ]
    }

    scenario 'user prints the PER' do
      login
      visit detainee_path(detainee)
      profile.click_print

      pdf_text = transform_pdf_to_lines_of_text(page.body).join
      expected_text = expected_lines.join

      expect(pdf_text).to eql expected_text
    end
  end

  def transform_pdf_to_lines_of_text(pdf_contents)
    pdf = pdf_file(pdf_contents)
    extract_lines_of_text(pdf)
  end

  def pdf_file(pdf_contents)
    Tempfile.new('tempfile').tap do |f|
      f.binmode
      f << pdf_contents
    end
  end

  def extract_lines_of_text(pdf_file)
    PDF::Reader.new(pdf_file).
      pages.
      flat_map(&:text).
      join.
      lines.
      reject{ |l| l == ?\n }.
      map(&:squish)
  end
end
