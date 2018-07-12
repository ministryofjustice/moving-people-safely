class AddCsraDetailsToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :csra_details, :text
  end
end
