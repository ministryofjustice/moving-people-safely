class RemoveSubstanceRiskOldColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :substance_use
    remove_column :risks, :substance_use_details
  end
end
