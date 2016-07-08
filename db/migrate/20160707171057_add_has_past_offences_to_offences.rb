class AddHasPastOffencesToOffences < ActiveRecord::Migration[5.0]
  def change
    add_column :offences, :has_past_offences, :string, default: 'unknown'
  end
end
