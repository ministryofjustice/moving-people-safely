class AddSpecialTransportRequirementsToMoves < ActiveRecord::Migration[5.2]
  def change
    add_column :moves, :require_special_vehicle, :string
    add_column :moves, :require_special_vehicle_details, :text
    add_column :moves, :other_transport_requirements, :string
    add_column :moves, :other_transport_requirements_details, :text
  end
end
