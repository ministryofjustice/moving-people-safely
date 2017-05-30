class AddIssuedAtToEscorts < ActiveRecord::Migration[5.0]
  def change
    add_column :escorts, :issued_at, :timestamp
  end
end
