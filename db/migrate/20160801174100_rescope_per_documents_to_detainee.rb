class RescopePerDocumentsToDetainee < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :detainee_id, :uuid
    add_column :healthcare, :detainee_id, :uuid
    add_column :offences, :detainee_id, :uuid
    add_column :moves, :detainee_id, :uuid
  end
end
