class ChangeDiscriminationColumnsInRisk < ActiveRecord::Migration[5.0]
  def change
    change_column :risks, :risk_to_females, :string
    change_column :risks, :homophobic, :string
    change_column :risks, :racist, :string
    change_column :risks, :other_violence_due_to_discrimination, :string
  end
end
