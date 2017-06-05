class DeleteMedicationsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :medications, id: :uuid do |t|
      t.uuid     :healthcare_id
      t.string   :description
      t.string   :administration
      t.string   :carrier

      t.timestamps
    end
  end
end
