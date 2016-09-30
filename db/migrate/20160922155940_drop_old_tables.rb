class DropOldTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :past_offences
    drop_table :current_offences
    drop_table :offences
    drop_table :destinations
    drop_table :healthcare
    drop_table :medications
    drop_table :risks
  end
end
