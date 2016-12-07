class AddHighProfileColumnToRisksTable < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :high_profile, :string
    add_column :risks, :high_profile_details, :text
  end
end
