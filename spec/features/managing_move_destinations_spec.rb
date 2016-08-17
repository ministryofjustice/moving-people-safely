require 'feature_helper'

RSpec.describe 'managing move destinations', type: :feature do
  scenario 'adding and removing move destinations' do
    detainee = create(:detainee, :with_active_move)
    move = detainee.active_move
    login

    visit move_information_path(move)
    fill_in_move_information

    fill_in_destination position: :first
    add_destination
    fill_in_destination position: :second
    add_destination
    fill_in_destination position: :third
    save

    visit move_information_path(move)
    expect_to_have_destinations_for positions: %i[ first second third ]

    delete_destination position: :third
    save

    visit move_information_path(move)
    expect_to_have_destinations_for positions: %i[ first second ]

    select_no_destinations
    save

    visit move_information_path(move)
    expect_all_destinations_to_be_deleted
  end

  def expect_to_have_destinations_for(positions:)
    expect(destination_els.size).to eq positions.size
    positions.each do |position|
      within_destination(position) do
        expect(find_field('Establishment').value).to eq text_for(:establishment, position)
        expect(has_checked_field?('Must NOT return')).to be true
        expect(find_field('reasons').value).to eq text_for(:reasons, position)
      end
    end
  end

  def expect_all_destinations_to_be_deleted
    expect(destination_els.size).to eq 1
    within_destination(:first) do
      expect(find_field('Establishment').value).to be_blank
      expect(find_field('reasons').value).to be_blank
    end
  end

  def fill_in_move_information
    fill_in 'Date', with: '2/3/2036'
    choose 'Yes'
  end

  def select_no_destinations
    choose 'No'
  end

  def add_destination
    click_button 'Add establishment'
  end

  def fill_in_destination(position:)
    within_destination(position) do
      fill_in 'Establishment', with: text_for(:establishment, position)
      choose 'Must NOT return'
      fill_in 'reasons', with: text_for(:reasons, position)
    end
  end

  def save
    click_button 'Save'
  end

  def delete_destination(position:)
    within_destination(position) { check 'Remove' }
  end

  def destination_els
    all('.multiple-wrapper').to_a
  end

  def within_destination(position, &_blk)
    within(destination_els.send(position)) { yield }
  end

  def text_for(field, position)
    case field
    when :establishment then "Establishment #{position}"
    when :reasons then "Reason #{position}"
    end
  end
end
