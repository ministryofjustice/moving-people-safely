module Page
  class MoveDetails < Base
    def complete_form(move)
      fill_in 'From', with: move.from
      fill_in 'To', with: move.to
      fill_in 'Date', with: move.date
      choose move.reason.titlecase
      if move.reason_details
        fill_in 'information[reason_details]', with: move.reason_details
      end
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
      click_button 'Save and continue'
    end
  end
end
