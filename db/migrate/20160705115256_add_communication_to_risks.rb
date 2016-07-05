class AddCommunicationToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :interpreter_required, :string, default: 'unknown'
    add_column :risks, :language, :text
    add_column :risks, :hearing_speach_sight, :string, default: 'unknown'
    add_column :risks, :hearing_speach_sight_details, :text
    add_column :risks, :can_read_and_write, :string, default: 'unknown'
    add_column :risks, :can_read_and_write_details, :text
  end
end
