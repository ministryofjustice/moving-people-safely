class AddToTypeToMoves < ActiveRecord::Migration[5.0]
  def up
    add_column :moves, :to_type, :string

    say_with_time "Evaluating `to_type` in moves..." do
      moves = Move.all

      moves.each do |move| 
        to_type = case 
                  when move.to.match(/Crown| CC|Luton County Court/i)
                    'crown_court'
                  when move.to.match(/Magistrates|Mag| MC| M C/)
                    'magistrates_court'
                  when move.to.match(/ST ALBANS/)
                    'crown_court'
                  when move.to.match(/HMP|the mount/i)
                    'prison'
                  when move.to.match(/treatment/i)
                    'hospital'
                  else
                    'other'
                  end

        move.update_attribute(:to_type, to_type)
      end

      moves.size
    end
  end

  def down
    remove_column :moves, :to_type
  end
end
