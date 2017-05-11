class AddNewDiscriminationColumnToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :discrimination_to_other_religions, :string
    add_column :risks, :discrimination_to_other_religions_details, :text
  end
end
