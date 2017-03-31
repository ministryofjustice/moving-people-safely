class AddDeletedAtToEscorts < ActiveRecord::Migration[5.0]
  def change
    add_column :escorts, :deleted_at, :datetime
    add_index :escorts, :deleted_at
  end
end
