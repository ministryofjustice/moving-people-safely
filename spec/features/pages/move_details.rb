module Page
  class MoveDetails < Base
    def complete_form(move)
      fill_in 'From', with: move.from
      fill_in 'To', with: move.to
      fill_in 'Date', with: move.date
      fill_in_not_for_release_details(move)
      fill_in_destinations
      save_and_continue
    end

    def complete_date_field(date)
      fill_in 'Date', with: date
      save_and_continue
    end

    private

    def fill_in_not_for_release_details(move)
      if move.not_for_release == 'yes'
        choose 'information_not_for_release_yes'
        choose "information_not_for_release_reason_#{move.not_for_release_reason}"
        if move.not_for_release_reason == 'other'
          fill_in 'information_not_for_release_reason_details', with: move.not_for_release_reason_details
        end
      else
        choose 'information_not_for_release_no'
      end
    end

    def fill_in_destinations
      choose 'information_has_destinations_yes'
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
  end
end
