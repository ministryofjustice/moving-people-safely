class AddCancellerToEscort < ActiveRecord::Migration[5.0]
  def change
    add_column :escorts, :canceller_id, :integer
    add_column :escorts, :cancelled_at, :datetime
    add_column :escorts, :cancelling_reason, :text
  end
end
