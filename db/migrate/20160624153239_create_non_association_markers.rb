class CreateNonAssociationMarkers < ActiveRecord::Migration[5.0]
  def change
    create_table :non_association_markers, id: :uuid do |t|
      t.uuid :risks_id
      t.text :details

      t.timestamps
    end
  end
end
