class AddApprovedAtToEscorts < ActiveRecord::Migration[5.2]
  def change
    add_column :escorts, :approved_at, :datetime
    add_column :escorts, :approver_id, :integer
  end
end
