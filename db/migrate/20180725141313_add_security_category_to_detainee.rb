class AddSecurityCategoryToDetainee < ActiveRecord::Migration[5.2]
  def change
    add_column :detainees, :security_category, :string
  end
end
