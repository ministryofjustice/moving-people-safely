class RemoveNonAssociatedMarkersRiskColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :non_association_markers
    remove_column :risks, :non_association_markers_details
  end
end
