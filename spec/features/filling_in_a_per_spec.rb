require 'rails_helper'

RSpec.feature 'filling in a PER', type: :feature do
  around(:each) do |example|
    travel_to(Time.new(2016, 7, 3, 9, 30, 0)) { example.run }
  end

  scenario 'adding a new escort and filling it in' do
    login
    binding.pry
    search_prisoner
    create_new_detainee_profile
    expect_prison_number_to_be_autofilled

    fill_in_detainee_details
    save

    fill_in_move_information
    save

    expect_profile_page_to_have_detainee_details
    expect_profile_page_to_have_move

    go_to_healthcare_page
    fill_in_physical_healthcare
    save_and_continue
    fill_in_mental_healthcare
    save_and_continue
    fill_in_social_healthcare
    save_and_continue
    fill_in_allergies
    save_and_continue
    fill_in_healthcare_needs
    save_and_continue
    fill_in_transport
    save_and_continue
    fill_in_medical_contact
    save_and_continue

    review_summary_page

    expect_profile_page_with_completed_healthcare

    go_to_risk_page
    fill_in_risk_to_self
    save_and_continue
    fill_in_risk_from_others
    save_and_continue
    fill_in_violence
    save_and_continue
    fill_in_harassments
    save_and_continue
    fill_in_sex_offences
    save_and_continue
    fill_in_non_association_markers
    save_and_continue
    fill_in_security
    save_and_continue
    fill_in_substance_misuse
    save_and_continue
    fill_in_concealed_weapons
    save_and_continue
    fill_in_arson
    save_and_continue
    fill_in_communication
    save_and_continue

    review_summary_page

    expect_profile_page_with_completed_risk

    go_to_offences_page
    fill_in_offences
    save_and_continue

    expect_profile_page_with_completed_offences

    expect_profile_page_to_have_header
  end

  def search_prisoner
    fill_in 'search_prison_number', with: 'A1234BC'
    click_button 'Search'
  end

  def expect_prison_number_to_be_autofilled
    expect(page).to have_content 'Prison numberA1234BC'
  end

  def create_new_detainee_profile
    click_button 'Create new profile'
  end

  def fill_in_detainee_details
    fill_in 'Surname', with: 'Trump'
    fill_in 'Forename(s)', with: 'Donald'
    fill_in 'Date of birth', with: '14/06/1946'
    fill_in 'Nationalities', with: 'American'
    choose 'Male'
    fill_in 'PNC number', with: 'PNC123'
    fill_in 'CRO number', with: 'CRO987'
    fill_in 'Aliases', with: 'Donald duck'
  end

  def fill_in_move_information
    fill_in 'From', with: 'Some prison'
    fill_in 'To', with: 'Some court'
    fill_in 'Date', with: '12/09/2016'
    choose 'Other'
    fill_in 'information[reason_details]', with: 'Has to move'
    choose 'Yes'
    fill_in 'information_destinations_attributes_0_establishment', with: 'Hospital'
    choose 'information_destinations_attributes_0_must_return_must_return'
    click_button 'Add establishment'
    fill_in 'information_destinations_attributes_1_establishment', with: 'Court'
    choose 'information_destinations_attributes_1_must_return_must_return'
    click_button 'Add establishment'
    fill_in 'information_destinations_attributes_2_establishment', with: 'Dentist'
    choose 'information_destinations_attributes_2_must_return_must_not_return'
    click_button 'Add establishment'
    fill_in 'information_destinations_attributes_3_establishment', with: 'Tribunal'
    choose 'information_destinations_attributes_3_must_return_must_not_return'
  end

  def expect_profile_page_to_have_detainee_details
    within('#personal-details') do
      expect(page).to have_link('Edit', href: detainee_details_path(escort))
      expect(page).to have_content('A1234BC')
      expect(page).to have_content('14 Jun 1946')
      expect(page).to have_content('American')
      expect(page).to have_content('M')
      expect(page).to have_content('PNC123')
      expect(page).to have_content('CRO987')
      expect(page).to have_content('Donald duck')
      expect(page).to have_content('70')
    end
  end

  def expect_profile_page_to_have_move
    within('.move-information') do
      expect(page).to have_link('Edit', href: move_information_path(escort))
      expect(page).to have_content('Some court')
      expect(page).to have_content('12 Sep 2016')
      expect(page).to have_content('Has to move')
      expect(page).to have_content('Hospital, Court')
      expect(page).to have_content('Dentist, Tribunal')
    end
  end

  def go_to_healthcare_page
    within('#healthcare') do
      click_link 'Edit'
    end
  end

  def fill_in_physical_healthcare
    choose 'physical_physical_issues_yes'
    fill_in 'physical[physical_issues_details]', with: 'Back pain'
  end

  def fill_in_mental_healthcare
    choose 'mental_mental_illness_yes'
    fill_in 'mental[mental_illness_details]', with: 'Depressed'
    choose 'mental_phobias_yes'
    fill_in 'mental[phobias_details]', with: 'Spiders'
  end

  def fill_in_social_healthcare
    choose 'social_personal_hygiene_yes'
    fill_in 'social[personal_hygiene_details]', with: 'Dirty guy'
    choose 'social_personal_care_yes'
    fill_in 'social[personal_care_details]', with: 'Not taking care'
  end

  def fill_in_allergies
    choose 'allergies_allergies_yes'
    fill_in 'allergies[allergies_details]', with: 'Nuts'
  end

  def fill_in_healthcare_needs
    choose 'needs_dependencies_yes'
    fill_in 'needs[dependencies_details]', with: 'Heroin'
    choose 'needs_has_medications_yes'
    fill_in 'Description', with: 'Aspirin'
    fill_in 'Administration', with: 'Once a day'
    select 'Detainee', from: 'Carrier'
  end

  def fill_in_transport
    choose 'transport_mpv_yes'
    fill_in 'transport[mpv_details]', with: 'Wheel chair'
  end

  def fill_in_medical_contact
    fill_in 'Healthcare professional', with: 'Doctor Robert'
    fill_in 'Contact number', with: '079876543'
  end

  def expect_profile_page_with_completed_healthcare
    visit profile_path(escort)
    within('#healthcare') do
      expect(page).to have_content('Complete')
      within('.answered_yes') do
        expect(page).to have_content('9')
      end
      within('.answered_no') do
        expect(page).to have_content('0')
      end
    end
  end

  def go_to_risk_page
    within('#risk') do
      click_link 'Edit'
    end
  end

  def fill_in_risk_to_self
    choose 'risk_to_self_open_acct_yes'
    fill_in 'risk_to_self[open_acct_details]', with: 'Needs ACCT'
    choose 'risk_to_self_suicide_yes'
    fill_in 'risk_to_self[suicide_details]', with: 'Tried twice'
  end

  def fill_in_risk_from_others
    choose 'risk_from_others_rule_45_yes'
    fill_in 'risk_from_others[rule_45_details]', with: 'Details for Rule 45'
    choose 'risk_from_others_csra_high'
    fill_in 'risk_from_others[csra_details]', with: 'High CSRA'
    choose 'risk_from_others_verbal_abuse_yes'
    fill_in 'risk_from_others[verbal_abuse_details]', with: 'Details for verbal abuse'
    choose 'risk_from_others_physical_abuse_yes'
    fill_in 'risk_from_others[physical_abuse_details]', with: 'Details for physical abuse'
  end

  def fill_in_violence
    choose 'violence_violent_yes'
    check 'Prison staff'
    fill_in 'violence[prison_staff_details]', with: 'Details for violent to prison stuff'
  end

  def fill_in_harassments
    choose 'harassments_stalker_harasser_bully_yes'
    check 'Intimidator'
    fill_in 'harassments[intimidator_details]', with: 'Aggressive personality'
  end

  def fill_in_sex_offences
    choose 'sex_offences_sex_offence_yes'
    choose 'Under 18'
    fill_in 'sex_offences[sex_offence_details]', with: '17 years old'
  end

  def fill_in_security
    choose 'security_current_e_risk_yes'
    fill_in 'security[current_e_risk_details]', with: 'There is current E risk'
    choose 'security_escape_list_yes'
    fill_in 'security[escape_list_details]', with: 'Tried 2 times'
    choose 'security_other_escape_risk_info_yes'
    fill_in 'security[other_escape_risk_info_details]', with: 'Used a hammer'
    choose 'security_category_a_yes'
    fill_in 'security[category_a_details]', with: 'Category A information'
    choose 'security_restricted_status_yes'
    fill_in 'security[restricted_status_details]', with: 'Restricted status details info'
    check 'Escape pack'
    check 'Escape risk assessment'
    check 'Cuffing protocol'
  end

  def fill_in_non_association_markers
    choose 'non_association_markers_non_association_markers_yes'
    fill_in 'non_association_markers[non_association_markers_details]', with: 'Prisoner A1234BC and Z9876XY'
  end

  def fill_in_substance_misuse
    choose 'substance_misuse_drugs_yes'
    fill_in 'substance_misuse[drugs_details]', with: 'Heroin'
    choose 'substance_misuse_alcohol_yes'
    fill_in 'substance_misuse[alcohol_details]', with: 'Lots of beer'
  end

  def fill_in_concealed_weapons
    choose 'concealed_weapons_conceals_weapons_yes'
    fill_in 'concealed_weapons[conceals_weapons_details]', with: 'Guns and rifles'
  end

  def fill_in_arson
    choose 'arson_arson_yes'
    choose 'arson_arson_value_high'
    fill_in 'arson[arson_details]', with: 'Burnt several houses'
    choose 'arson_damage_to_property_no'
  end

  def fill_in_communication
    choose 'communication_interpreter_required_yes'
    fill_in 'communication[language]', with: 'German'
    choose 'communication_hearing_speach_sight_yes'
    fill_in 'communication[hearing_speach_sight_details]', with: 'Blind'
    choose 'communication_can_read_and_write_yes'
    fill_in 'communication[can_read_and_write_details]', with: 'Can only read'
  end

  def expect_profile_page_with_completed_risk
    visit profile_path(escort)
    within('#risk') do
      expect(page).to have_content('Complete')
      within('.answered_yes') do
        expect(page).to have_content('22')
      end
      within('.answered_no') do
        expect(page).to have_content('1')
      end
    end
  end

  def go_to_offences_page
    within('#offences') do
      click_link 'Edit'
    end
  end

  def fill_in_offences
    fill_in 'offences[release_date]', with: '05/07/2016'
    check 'offences[not_for_release]'
    fill_in 'offences_not_for_release_details', with: 'Serving Sentence'
    fill_in 'offences_current_offences_attributes_0_offence', with: 'Burglary'
    fill_in 'offences_current_offences_attributes_0_case_reference', with: 'Ref 3064'
    click_button 'Add offence'
    fill_in 'offences_current_offences_attributes_1_offence', with: 'Attempted murder'
    fill_in 'offences_current_offences_attributes_1_case_reference', with: 'Ref 7291'
    choose 'Yes'
    click_button 'Add past offence'
    fill_in 'offences_past_offences_attributes_0_offence', with: 'Arson'
    click_button 'Add past offence'
    fill_in 'offences_past_offences_attributes_1_offence', with: 'Armed robbery'
  end

  def expect_profile_page_with_completed_offences
    within('#offences') do
      expect(page).to have_content('Complete')
      expect(page).to have_content('Burglary')
      expect(page).to have_content('Attempted murder')
      expect(page).to have_content('Arson')
      expect(page).to have_content('Armed robbery')
    end
  end

  def expect_profile_page_to_have_header
    within('#header') do
      expect(page).to have_content('A1234BC: Trump, Donald')
      expect(page).to have_content('Serving Sentence')
      expect(page).to have_content('High CSRA')
      expect(page).to have_content('Needs ACCT')
      expect(page).to have_content('Details for Rule 45')
      expect(page).to have_content('Category A information')
    end
  end

  def save
    click_button 'Save'
  end

  def save_and_continue
    click_button 'Save and continue'
  end

  def review_summary_page
    click_button 'Confirm and save'
  end

  def escort
    Escort.last
  end
end
