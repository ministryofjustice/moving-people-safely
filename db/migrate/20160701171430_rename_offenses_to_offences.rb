class RenameOffensesToOffences < ActiveRecord::Migration[5.0]
  def change
    rename_table :offenses, :offences
  end
end
