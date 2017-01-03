class AddSexOffenceNewColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :sex_offence_adult_male_victim, :boolean
    add_column :risks, :sex_offence_adult_female_victim, :boolean
    add_column :risks, :sex_offence_under18_victim, :boolean
    add_column :risks, :sex_offence_under18_victim_details, :text
  end
end
