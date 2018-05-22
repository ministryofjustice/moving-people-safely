class AddViolentOrDangerous < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :violent_or_dangerous, :string
    add_column :risks, :violent_or_dangerous_details, :text
  end
end
