class RemoveViolenceDueToDiscriminationColumnFromRisks < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :violence_due_to_discrimination, :string
  end
end
