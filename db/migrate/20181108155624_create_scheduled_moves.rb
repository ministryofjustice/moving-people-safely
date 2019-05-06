class CreateScheduledMoves < ActiveRecord::Migration[5.2]
  def change
    create_table :scheduled_moves, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :escort_id
      t.string :violent
      t.string :suicide
      t.string :self_harm
      t.string :escape_risk
      t.string :segregation
      t.string :medical
    end
  end
end
