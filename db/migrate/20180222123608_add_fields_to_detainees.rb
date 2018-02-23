class AddFieldsToDetainees < ActiveRecord::Migration[5.1]
  def change
    add_column :detainees, :language, :string
    add_column :detainees, :interpreter_required, :string
    add_column :detainees, :diet, :string
  end
end
