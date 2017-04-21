class RemoveDamageToPropertyFromRisks < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :damage_to_property
  end
end
