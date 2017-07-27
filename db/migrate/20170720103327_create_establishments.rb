class CreateEstablishments < ActiveRecord::Migration[5.0]
  def change
    create_table :establishments, id: :uuid do |t|
      t.string :name
      t.string :type, index: true
      t.string :nomis_id, index: { unique: true }
      t.string :sso_id, index: { unique: true }
    end
  end
end
