class AddTimeStampsToRisks < ActiveRecord::Migration[5.0]
  def change
    add_timestamps(:risks)
  end
end
