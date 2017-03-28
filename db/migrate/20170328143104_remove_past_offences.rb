class RemovePastOffences < ActiveRecord::Migration[5.0]
  def change
    remove_column :offences, :has_past_offences
    drop_table :past_offences
  end
end
