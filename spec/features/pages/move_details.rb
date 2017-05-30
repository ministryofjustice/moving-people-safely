module Page
  class MoveDetails < Base
    def complete_form(move, options = {})
      fill_in 'From', with: move.from
      fill_in 'To', with: move.to
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
  end
end
