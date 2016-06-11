class CreateMoves < ActiveRecord::Migration[5.0]
  def change
    create_table :moves do |t|
      t.uuid :escort_id
      t.string :from
      t.string :to
      t.date :date
      t.string :reason

      t.timestamps
    end
  end
end
