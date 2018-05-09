class SimplifyControlledUnlockAtts < ActiveRecord::Migration[5.2]
  MAP = {
    'two_officer_unlock' => '2 officer unlock.',
    'three_officer_unlock' => '3 officer unlock.',
    'four_officer_unlock' => '4 officer unlock.',
    'more_than_four' => 'More than 4 officers.'
  }.freeze

  def up
    say_with_time 'Moving num. officers to controlled unlock details...' do
      risks = Risk.where(controlled_unlock_required: 'yes')
                  .where('controlled_unlock IS NOT NULL')

      risks.each do |risk|
        num_officers_text = MAP[risk.controlled_unlock]
        details = "#{num_officers_text} #{risk.controlled_unlock_details}"
        risk.update_column(:controlled_unlock_details, details)
      end

      risks.size
    end

    remove_column :risks, :controlled_unlock
  end

  def down
    add_column :risks, :controlled_unlock, :string

    say_with_time "Moving num. officers to it's own column..." do
      risks = Risk.where(controlled_unlock_required: 'yes')

      risks.each do |risk|
        num_officers_text = find_text(risk.controlled_unlock_details)
        next unless num_officers_text

        modified_details = risk.controlled_unlock_details
                               .sub(num_officers_text, '').strip

        risk.update_columns(controlled_unlock_details: modified_details,
                            controlled_unlock: MAP.key(num_officers_text))
      end

      risks.size
    end
  end

  def find_text(str)
    MAP.values.each do |search_string|
      return search_string if str.match(search_string)
    end

    nil
  end
end
