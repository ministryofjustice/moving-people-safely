class ChangeHostageTakerDatesToStrings < ActiveRecord::Migration[5.0]
  def up
    COLUMNS.each do |column|
      add_column :risks, append_text_to_name(column), :string, null: true
    end

    say_with_time "Migrating risk records" do
      risks = Risk.all

      risks.each do |risk|
        next if all_columns_blank?(risk)
        update_text_columns(risk)
      end

      risks.size
    end

    COLUMNS.each do |column|
      remove_column :risks, column
      rename_column :risks, append_text_to_name(column), column
    end
  end

  def down
    COLUMNS.each do |column|
      add_column :risks, append_date_to_name(column), :date
    end

    say_with_time "Migrating risk records" do
      risks = Risk.all

      risks.each do |risk|
        next if all_columns_blank?(risk)
        update_date_columns(risk)
      end

      risks.size
    end

    COLUMNS.each do |column|
      remove_column :risks, column
      rename_column :risks, append_date_to_name(column), column
    end
  end

  private

  COLUMNS = %i[
    date_most_recent_staff_hostage_taker_incident
    date_most_recent_prisoners_hostage_taker_incident
    date_most_recent_public_hostage_taker_incident
  ]

  def all_columns_blank?(risk)
    COLUMNS.all? { |column| risk.send(column).blank? }
  end

  def append_text_to_name(name)
    "#{name}_text".to_sym
  end

  def append_date_to_name(name)
    "#{name}_date".to_sym
  end

  def update_text_columns(risk)
    COLUMNS.each do |column|
      unless risk.send(column).blank?
        risk.update_column(
          append_text_to_name(column).to_sym,
          risk.send(column).to_s
        )
      end
    end
  end

  def update_date_columns(risk)
    COLUMNS.each do |column|
      unless risk.send(column).blank?
        risk.update_column(
          append_date_to_name(column).to_sym,
          Date.parse(risk.send(column))
        )
      end
    end
  end
end
