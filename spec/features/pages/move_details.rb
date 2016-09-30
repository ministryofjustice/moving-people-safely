module Page
  class MoveDetails < Base
    def complete_form(move)
      fill_in 'From', with: move.from
      fill_in 'To', with: move.to
      fill_in 'Date', with: move.date
      choose move.reason.titlecase
      if move.reason_details
        fill_in 'Reason details', with: move.reason_details
      end
      save_and_continue
    end

    def complete_date_field(date)
      fill_in 'Date', with: date
      save_and_continue
    end
  end
end
