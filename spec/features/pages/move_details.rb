module Page
  class MoveDetails < Base
    def complete_form(move, options = {})
      fill_in_destination_details(move)
      fill_in 'Date', with: move.date
      fill_in_not_for_release_details(move)
      save_and_continue
    end

    def complete_date_field(date)
      fill_in 'Date', with: date
      save_and_continue
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
      case move.to_type
      when 'crown_court'
        choose 'crown_court_toggler'
        select move.to, from: 'crown_court'
      when 'magistrates_court'
        choose 'magistrates_court_toggler'
        select move.to, from: 'magistrates_court'
      when 'prison'
        choose 'prison_toggler'
        select move.to, from: 'prison'
      when 'hospital'
        choose 'hospital_toggler'
        fill_in 'hospital-text', with: move.to
      when 'other'
        choose 'other_toggler'
        fill_in 'other-text', with: move.to
      else
        raise "Unexpected value for 'move.to_type': #{move.to_type}"
      end
    end
  end
end
