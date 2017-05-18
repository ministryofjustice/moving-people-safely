require 'feature_helper'

RSpec.describe 'managing healthcare medications', type: :feature do
  let(:detainee) { create(:detainee) }
  let(:move) { create(:move, :active) }
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
        expect(find_field('What is it?').value).to eq text_for(:description, position)
        expect(find_field('How is it given?').value).to eq text_for(:administration, position)
        expect(has_select?('Who carries it?', selected: 'Escort')).to be true
      end
    end
  end

  def expect_all_medications_to_be_deleted
    expect(medication_els.size).to eq 1
    within_medication(:first) do
      expect(find_field('What is it?', visible: false).value).to be_blank
      expect(find_field('How is it given?', visible: false).value).to be_blank
    end
  end

  def check_medication
    within_fieldset('Regular medication?') do
      choose 'Yes'
    end
  end

  def select_no_medications
    within_fieldset('Regular medication?') do
      choose 'No'
    end
  end

  def add_medication
    click_button 'Add medication'
  end

  def fill_in_medication(position:)
    within_medication(position) do
      fill_in 'What is it?', with: text_for(:description, position)
      fill_in 'How is it given?', with: text_for(:administration, position)
      select 'Escort', from: 'Who carries it?'
    end
  end

  def save
    click_button 'Save and continue'
  end

  def delete_medication(position:)
    within_medication(position) {
      find('label', text: 'Remove').click || check('Remove')
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
    end
  end
end
