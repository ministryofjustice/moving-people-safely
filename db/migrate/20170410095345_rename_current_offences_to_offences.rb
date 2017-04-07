class RenameCurrentOffencesToOffences < ActiveRecord::Migration[5.0]
  def change
    rename_table :current_offences, :offences
  end
end
