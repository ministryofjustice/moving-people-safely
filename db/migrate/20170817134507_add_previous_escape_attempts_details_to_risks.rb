class AddPreviousEscapeAttemptsDetailsToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :previous_escape_attempts_details, :text
  end
end
