class RemoveDatafix < ActiveRecord::Migration[5.2]
  def change
    drop_table :datafix_log
  end
end
