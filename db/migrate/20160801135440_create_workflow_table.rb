class CreateWorkflowTable < ActiveRecord::Migration[5.0]
  def change
    create_table :workflows, id: :uuid do |t|
      t.uuid :move_id
      t.string :type, null: false

      t.integer :status, default: 0
      t.uuid :reviewed_by
      t.timestamp :reviewed_at

      t.timestamps
    end
  end
end
