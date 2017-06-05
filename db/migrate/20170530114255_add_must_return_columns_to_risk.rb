class AddMustReturnColumnsToRisk < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :must_return, :string
    add_column :risks, :must_return_to, :string
    add_column :risks, :must_return_to_details, :text
  end
end
