class CreateOffenses < ActiveRecord::Migration[5.0]
  def change
    create_table :offenses, id: :uuid do |t|
      t.uuid    :escort_id
      t.date    :release_date
      t.boolean :not_for_release
      t.text    :not_for_release_reason
      t.timestamps
    end
  end
end
