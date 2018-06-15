class AddInterpreterRequiredDetailsToDetainees < ActiveRecord::Migration[5.2]
  def change
    add_column :detainees, :interpreter_required_details, :text
  end
end
