class AddSubstanceMisuseToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :drugs, :string, default: 'unknown'
    add_column :risks, :drugs_details, :text
    add_column :risks, :alcohol, :string, default: 'unknown'
    add_column :risks, :alcohol_details, :text
  end
end
