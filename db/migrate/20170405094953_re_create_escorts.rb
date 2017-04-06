class ReCreateEscorts < ActiveRecord::Migration[5.0]
  def change
    create_table :escorts, id: :uuid do |t|
      t.string :prison_number
      t.timestamps
    end
    add_index :escorts, :prison_number
  end
end
