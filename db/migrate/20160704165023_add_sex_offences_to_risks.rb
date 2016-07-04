class AddSexOffencesToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :sex_offence, :string, default: 'unknown'
    add_column :risks, :sex_offence_victim, :string
    add_column :risks, :sex_offence_details, :text
  end
end
