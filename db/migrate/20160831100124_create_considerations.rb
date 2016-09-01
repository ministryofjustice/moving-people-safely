class CreateConsiderations < ActiveRecord::Migration[5.0]
  def change
    create_table :considerations do |t|
      t.string :name
      t.jsonb :properties, default: {}
      t.string :type

      t.uuid "detainee_id"
      t.index ["detainee_id"], name: "index_considerations_on_detainee_id", using: :btree
      t.timestamps
    end
  end
end
