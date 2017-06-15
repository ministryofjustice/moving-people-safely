class RemoveDefaultUnknown < ActiveRecord::Migration[5.0]
  def change
    change_column_default :healthcare, :physical_issues, nil
    change_column_default :healthcare, :mental_illness, nil
    change_column_default :healthcare, :personal_care, nil
    change_column_default :healthcare, :allergies, nil
    change_column_default :healthcare, :dependencies, nil
    change_column_default :healthcare, :has_medications, nil
    change_column_default :healthcare, :mpv, nil

    change_column_default :risks, :rule_45, nil
    change_column_default :risks, :csra, nil
    change_column_default :risks, :sex_offence, nil
    change_column_default :risks, :current_e_risk, nil
    change_column_default :risks, :category_a, nil
    change_column_default :risks, :substance_supply, nil
    change_column_default :risks, :conceals_weapons, nil
    change_column_default :risks, :arson, nil
  end
end
