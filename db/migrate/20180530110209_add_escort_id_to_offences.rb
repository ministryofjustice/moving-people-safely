class AddEscortIdToOffences < ActiveRecord::Migration[5.2]
  def change
    add_column :offences, :escort_id, :uuid

    Offence.all.each { |o| o.update_column :escort_id, Detainee.find(o.detainee_id)&.escort&.id }
  end
end
