class AddEthnicityAndReligionToDetainees < ActiveRecord::Migration[5.0]
  def change
    add_column :detainees, :ethnicity, :string
    add_column :detainees, :religion, :string
  end
end
