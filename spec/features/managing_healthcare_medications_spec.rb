require 'rails_helper'

RSpec.describe 'managing healthcare medications', type: :feature do
  let(:escort) { Escort.new.tap {|e| e.build_healthcare && e.save } }

  scenario 'adding and removing move medications' do
    login

    visit healthcare_path(escort, :needs)
    check_medication

    fill_in_medication position: :first
    add_medication
    fill_in_medication position: :second
    add_medication
    fill_in_medication position: :third
    save

    visit healthcare_path(escort, :needs)
    expect_to_have_medications_for positions: %i[ first second third ]

    delete_medication position: :third
    save

    visit healthcare_path(escort, :needs)
    expect_to_have_medications_for positions: %i[ first second ]

    select_no_medications
    save

    visit healthcare_path(escort, :needs)
    expect_all_medications_to_be_deleted
  end

  def expect_to_have_medications_for(positions:)
    expect(medication_els.size).to eq positions.size
    positions.each do |position|
      within_medication(position) do
        expect(find_field('Description').value).to eq text_for(:description, position)
        expect(find_field('Administration').value).to eq text_for(:administration, position)
        expect(has_select?('Carrier', selected: 'Escort')).to be true
      end
    end
  end

  def expect_all_medications_to_be_deleted
    expect(medication_els.size).to eq 1
    within_medication(:first) do
      expect(find_field('Description').value).to be_blank
      expect(find_field('Administration').value).to be_blank
    end
  end

  def check_medication
    within('.medication') do
      choose 'Yes'
    end
  end

  def select_no_medications
    within('.medication') do
      choose 'No'
    end
  end

  def add_medication
    click_button 'Add medication'
  end

  def fill_in_medication(position:)
    within_medication(position) do
      fill_in 'Description', with: text_for(:description, position)
      fill_in 'Administration', with: text_for(:administration, position)
      select 'Escort', from: 'Carrier'
    end
  end

  def save
    click_button 'Save and continue'
  end

  def delete_medication(position:)
    within_medication(position) { check 'Remove' }
  end

  def medication_els
    all('.optional-section').to_a
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
