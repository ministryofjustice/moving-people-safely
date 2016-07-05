class AddNonAssociationMarkersToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :non_association_markers, :string, default: 'unknown'
    add_column :risks, :non_association_markers_details, :text
  end
end
