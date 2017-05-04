class AddControlledUnlockRequiredToRiskToOthers < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :controlled_unlock_required, :string
    add_column :risks, :controlled_unlock, :string
    add_column :risks, :controlled_unlock_details, :text
  end
end
