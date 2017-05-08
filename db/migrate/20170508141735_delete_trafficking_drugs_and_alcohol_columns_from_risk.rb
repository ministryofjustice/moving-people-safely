class DeleteTraffickingDrugsAndAlcoholColumnsFromRisk < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :trafficking_drugs
    remove_column :risks, :trafficking_alcohol
  end
end
