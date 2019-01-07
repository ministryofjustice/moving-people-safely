module Page
  class Move < Base
    def complete_form(move, options = {})
      location = options.fetch(:location, :prison)
      gender = options.fetch(:gender, :male).to_sym

      fill_in_destination_details(move)
      fill_in 'Date', with: move.date
      fill_in_not_for_release_details(move)
      fill_in_travelling_with_child_details(move, gender) if location == :prison
      save_and_continue
    end

    def confirm_special_vehicle_values(move)
      expect(page).to have_content move.require_special_vehicle_details
      expect(page).to have_content move.other_transport_requirements_details
    end

    private

    def fill_in_not_for_release_details(move)
      if move.not_for_release == 'yes'
        choose 'move_not_for_release_yes', visible: false
        choose "move_not_for_release_reason_#{move.not_for_release_reason}", visible: false
        if move.not_for_release_reason == 'other'
          fill_in 'move_not_for_release_reason_details', with: move.not_for_release_reason_details
        end
      else
        choose 'move_not_for_release_no', visible: false
      end
    end

    def fill_in_destination_details(move)
      case
      when Establishment::ESTABLISHMENT_TYPES.include?(move.to_type.to_sym)
        choose "move_to_type_#{move.to_type}", visible: false
        fill_in "move_to_#{move.to_type}", with: "#{move.to}\n"
      when Forms::Move::FREE_TEXT_DESTINATIONS.include?(move.to_type.to_sym)
        choose "move_to_type_#{move.to_type}", visible: false
        fill_in "move_to_#{move.to_type}", with: "#{move.to}\n"
      else
        raise "Unexpected value for 'move.to_type': #{move.to_type}"
      end
    end

    def fill_in_travelling_with_child_details(move, gender)
      if gender == :female
        if move.travelling_with_child == 'yes'
          choose 'move_travelling_with_child_yes', visible: false
          fill_in 'move_child_full_name', with: move.child_full_name
          fill_in 'move_child_date_of_birth', with: move.child_date_of_birth
        else
          choose 'move_travelling_with_child_no', visible: false
        end
      else
        expect(page).not_to have_content('Are they travelling with a child')
      end
    end
  end
end
