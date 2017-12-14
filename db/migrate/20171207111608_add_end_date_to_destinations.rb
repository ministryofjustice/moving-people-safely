class AddEndDateToDestinations < ActiveRecord::Migration[5.0]
  def change
    add_column :establishments, :end_date, :string
  end
end
