require 'rails_helper'

RSpec.feature 'filling in a PER', type: :feature do
  scenario 'adding a new escort and filling it in' do
    login

    search_prisoner
    create_new_detainee_profile
    expect_prison_number_to_be_autofilled

    fill_in_detainee_details
    save

    expect_to_be_sent_to_profile_page

    expect_profile_page_to_have_links

    go_to_move_information_page
    fill_in_move_information
    save

    expect_to_be_sent_to_profile_page

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

    expect_to_be_sent_to_profile_page

    go_to_risks_page
    fill_in_risks_to_self
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

    expect_to_be_sent_to_profile_page
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
    fill_in 'Date of birth', with: '10/09/1985'
    fill_in 'Nationalities', with: 'American'
    choose 'Male'
  end

  def expect_profile_page_to_have_links
    expect(page).to have_link('Homepage', href: root_path)
    expect(page).to have_link('Detainee details', href: detainee_details_path(escort))
    expect(page).to have_link('Move information', href: move_information_path(escort))
  end

  def go_to_move_information_page
    click_link 'Move information'
  end

  def fill_in_move_information
    fill_in 'From', with: 'Some prison'
    fill_in 'To', with: 'Some court'
    fill_in 'Date', with: '12/09/2016'
    choose 'Other'
    fill_in 'move_information[reason_details]', with: 'Has to move'
    choose 'No'
  end

  def expect_to_be_sent_to_profile_page
    expect(current_path).to eq profile_path(escort)
  end

  def save
    click_button 'Save'
  end

  def go_to_healthcare_page
    click_link 'Healthcare'
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
    choose 'needs_medication_yes'
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

  def go_to_risks_page
    click_link 'Risks'
  end

  def fill_in_risks_to_self
    choose 'risks_to_self_open_acct_yes'
    fill_in 'risks_to_self[open_acct_details]', with: 'Needs ACCT'
    choose 'risks_to_self_suicide_yes'
    fill_in 'risks_to_self[suicide_details]', with: 'Tried twice'
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

  def save_and_continue
    click_button 'Save and continue'
  end

  def escort
    Escort.last
  end
end
