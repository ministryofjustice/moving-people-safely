class CreateEscorts < ActiveRecord::Migration[5.0]
  def change
    create_table :escorts, id: :uuid do |t|

      t.timestamps
    end
  end
end
