class AddEstablishmentToMoves < ActiveRecord::Migration[5.0]
  def change
    remove_column :moves, :from, :string
    add_column :moves, :from_establishment_id, :uuid
    bedford = Establishment.where(name: 'HMP/YOI Bedford').first
    Move.update_all(from_establishment_id: bedford.id) if bedford
  end
end
