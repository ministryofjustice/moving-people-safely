class CreateAudits < ActiveRecord::Migration[5.2]
  def change
    create_table :audits do |t|
      t.uuid :escort_id
      t.integer :user_id
      t.string :action

      t.timestamps
    end
  end
end
