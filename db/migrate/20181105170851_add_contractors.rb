class AddContractors < ActiveRecord::Migration[5.2]
  def change
    create_table :contractors, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :name

      t.timestamps
    end

    if defined?(Contractor) && Contractor.column_names.include?('name')
      Contractor.create(name: 'GeoAmey')
      Contractor.create(name: 'Serco')
    end

    add_column :establishments, :contractor_id, :uuid
    add_index :establishments, :contractor_id
  end
end
