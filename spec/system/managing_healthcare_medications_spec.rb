require 'feature_helper'

RSpec.describe 'managing healthcare medications', type: :system, js: true do
  let(:detainee) { create(:detainee) }
  let(:move) { create(:move) }
  let(:escort) { create(:escort, detainee: detainee, move: move) }

  scenario 'adding and removing move medications' do
    login

    visit new_escort_healthcare_path(escort, step: 'needs')
    check_medication

    fill_in_medication position: :first
    add_medication
    fill_in_medication position: :second
    add_medication
    fill_in_medication position: :third
    save

    visit edit_escort_healthcare_path(escort, step: 'needs')
    expect_to_have_medications_for positions: %i[ first second third ]
    delete_medication position: :third
    save

    visit edit_escort_healthcare_path(escort, step: 'needs')
    expect_to_have_medications_for positions: %i[ first second ]

    select_no_medications
    save

    visit edit_escort_healthcare_path(escort, step: 'needs')
    expect_all_medications_to_be_deleted
  end

  def expect_to_have_medications_for(positions:)
    expect(medication_els.size).to eq positions.size
    positions.each do |position|
      within_medication(position) do
        expect(find_field('Medicine').value).to eq text_for(:description, position)
        expect(find_field('How is it given').value).to eq text_for(:administration, position)
        within('.govuk-fieldset') do
          expect(find(:radio_button, checked: true, visible: false).value).to eq('escort')
        end
      end
    end
  end

  def expect_all_medications_to_be_deleted
    expect(medication_els.size).to eq 1
    within_medication(:first) do
      expect(find_field('Medicine', visible: false).value).to be_blank
      expect(find_field('How is it given', visible: false).value).to be_blank
    end
  end

  def check_medication
    within_fieldset('Will they need to be given medication while they are out of prison?') do
      choose 'Yes', visible: false
    end
  end

  def select_no_medications
    within_fieldset('Will they need to be given medication while they are out of prison?') do
      choose 'No', visible: false
    end
  end

  def add_medication
    click_button 'Add another medicine'
  end

  def fill_in_medication(position:)
    within_medication(position) do
      fill_in 'Medicine', with: text_for(:description, position)
      fill_in 'How is it given', with: text_for(:administration, position)
      fill_in 'Dosage', with: text_for(:dosage, position)
      fill_in 'When is it given?', with: text_for(:when_given, position)
      within('.govuk-fieldset') do
        choose 'Escort', visible: false
      end
    end
  end

  def save
    click_button 'Save and continue'
  end

  def delete_medication(position:)
    within_medication(position) {
      find('.remove-link label').click
    }
  end

  def medication_els
    all('.multiple-wrapper', visible: false).to_a
  end

  def within_medication(position, &_blk)
    within(medication_els.send(position)) { yield }
  end

  def text_for(field, position)
    case field
    when :description then "Description #{position}"
    when :administration then "Administration #{position}"
    when :dosage then "Dosage #{position}"
    when :when_given then "When given #{position}"
    end
  end
end
