class AddMultiples < ActiveRecord::Migration[5.0]
  def change
    create_table :medications, id: :uuid do |t|
      t.uuid     :healthcare_id
      t.string   :description
      t.string   :administration
      t.string   :dosage
      t.string   :when_given
      t.string   :carrier
    end

    create_table :must_not_return_details, id: :uuid do |t|
      t.uuid     :risk_id
      t.string   :establishment
      t.string   :establishment_details
    end
  end
end
