class AllowNullableOffencesIdOnOffences < ActiveRecord::Migration[5.0]
  def change
    change_column :current_offences, :offences_id, :uuid, null: true
  end
end
