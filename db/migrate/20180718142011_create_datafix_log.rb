class CreateDatafixLog < ActiveRecord::Migration[5.2]
  def self.up
    create_table :datafix_log do |t|
      t.string :direction
      t.string :script
      t.timestamp :timestamp
    end
  end

  def self.down
    drop_table :datafix_log
  end
end
