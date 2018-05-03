require_relative '../../db/migration_helpers/risk_simplifier_helper'

class SimplifySexOffenderAtts < ActiveRecord::Migration[5.2]
  include RiskSimplifierHelper

  def up
    add_column :risks, :sex_offences_details, :text

    say_with_time 'Simplifying sex offender attributes' do
      risks = Risk.where(sex_offence: 'yes')
      risks.each { |risk| risk.update_columns(simplify_sex_offender_attributes(risk)) }
      risks.size
    end

    remove_column :risks, :sex_offence_adult_male_victim
    remove_column :risks, :sex_offence_adult_female_victim
    remove_column :risks, :sex_offence_under18_victim
    remove_column :risks, :date_most_recent_sexual_offence
  end

  def down
    add_column :risks, :sex_offence_adult_male_victim, :boolean
    add_column :risks, :sex_offence_adult_female_victim, :boolean
    add_column :risks, :sex_offence_under18_victim, :boolean
    add_column :risks, :date_most_recent_sexual_offence, :text

    say_with_time 'Complexifying sex offender attributes' do
      risks = Risk.where(sex_offence: 'yes')
      risks.each { |risk| risk.update_columns(complexify_sex_offender_attributes(risk)) }
      risks.size
    end

    remove_column :risks, :sex_offences_details
  end
end
