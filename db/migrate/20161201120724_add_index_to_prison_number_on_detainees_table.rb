class AddIndexToPrisonNumberOnDetaineesTable < ActiveRecord::Migration[5.0]
  def change
    add_index :detainees, :prison_number
  end
end
