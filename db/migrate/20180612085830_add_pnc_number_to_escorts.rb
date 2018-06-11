class AddPncNumberToEscorts < ActiveRecord::Migration[5.2]
  def change
    add_column :escorts, :pnc_number, :string
    add_index :escorts, :pnc_number
  end
end
