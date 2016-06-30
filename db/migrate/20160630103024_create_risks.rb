class CreateRisks < ActiveRecord::Migration[5.0]
  def change
    create_table :risks, id: :uuid do |t|
      t.uuid   :escort_id
      t.string :open_acct, default: 'unknown'
      t.text   :open_acct_details
      t.string :suicide, default: 'unknown'
      t.text   :suicide_details
    end
  end
end
