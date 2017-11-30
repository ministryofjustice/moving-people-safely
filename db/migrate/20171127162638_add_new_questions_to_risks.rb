class AddNewQuestionsToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :vulnerable_prisoner, :string
    add_column :risks, :vulnerable_prisoner_details, :text
    add_column :risks, :pnc_warnings, :string
    add_column :risks, :pnc_warnings_details, :text
  end
end
