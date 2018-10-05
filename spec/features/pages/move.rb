module Page
  class Move < Base
    def complete_form(move, options = {})
      fill_in_destination_details(move)
      fill_in 'Date', with: move.date
      fill_in_not_for_release_details(move)
      save_and_continue
    end

    def confirm_special_vehicle_values(move)
      expect(page).to have_content move.require_special_vehicle_details
      expect(page).to have_content move.other_transport_requirements_details
    end

    private

    def fill_in_not_for_release_details(move)
      if move.not_for_release == 'yes'
        choose 'move_not_for_release_yes'
        choose "move_not_for_release_reason_#{move.not_for_release_reason}"
        if move.not_for_release_reason == 'other'
          fill_in 'move_not_for_release_reason_details', with: move.not_for_release_reason_details
        end
      else
        choose 'move_not_for_release_no'
      end
    end

    def fill_in_destination_details(move)
      case
      when Establishment::ESTABLISHMENT_TYPES.include?(move.to_type.to_sym)
        choose "#{move.to_type}-radio"
        select move.to, from: move.to_type
      when Forms::Move::FREE_FORM_DESTINATION_TYPES.include?(move.to_type.to_sym)
        choose "#{move.to_type}-radio"
        fill_in "#{move.to_type}-text", with: move.to
      else
        raise "Unexpected value for 'move.to_type': #{move.to_type}"
      end
    end
  end
end
