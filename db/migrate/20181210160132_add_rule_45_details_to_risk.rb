class AddRule45DetailsToRisk < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :rule_45_details, :text
  end
end
