class ChangeSexualOffenceDateToText < ActiveRecord::Migration[5.0]
  def up
    add_column :risks, :date_most_recent_sexual_offence_text, :string, null: true

    say_with_time "Migrating risk records" do
      risks = Risk.all

      risks.each do |risk| 
        next if risk.date_most_recent_sexual_offence.blank?
        risk.update_column(:date_most_recent_sexual_offence_text, risk.date_most_recent_sexual_offence.to_s)
      end

      risks.size
    end

    remove_column :risks, :date_most_recent_sexual_offence
    rename_column :risks, :date_most_recent_sexual_offence_text, :date_most_recent_sexual_offence
  end

  def down
    add_column :risks, :date_most_recent_sexual_offence_date, :date

    say_with_time "Migrating risk records" do
      risks = Risk.all

      risks.each do |risk| 
        next if risk.date_most_recent_sexual_offence.blank?
        risk.update_column(:date_most_recent_sexual_offence_date, Date.parse(risk.date_most_recent_sexual_offence))
      end

      risks.size
    end

    remove_column :risks, :date_most_recent_sexual_offence
    rename_column :risks, :date_most_recent_sexual_offence_date, :date_most_recent_sexual_offence
  end
end
