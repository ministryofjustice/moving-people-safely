class RemoveCommunicationRiskColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :interpreter_required
    remove_column :risks, :language
    remove_column :risks, :hearing_speach_sight
    remove_column :risks, :hearing_speach_sight_details
    remove_column :risks, :can_read_and_write
    remove_column :risks, :can_read_and_write_details
  end
end
