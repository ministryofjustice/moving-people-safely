class AddClonedIdToEscorts < ActiveRecord::Migration[5.0]
  def change
    add_reference :escorts, :cloned, type: :uuid, index: true
  end
end
