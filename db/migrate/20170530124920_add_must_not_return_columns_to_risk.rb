class AddMustNotReturnColumnsToRisk < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :must_not_return, :string
    add_column :risks, :must_not_return_details, :text
  end
end
