class AddPeepToDetainees < ActiveRecord::Migration[5.2]
  def change
    add_column :detainees, :peep, :string
    add_column :detainees, :peep_details, :text
  end
end
