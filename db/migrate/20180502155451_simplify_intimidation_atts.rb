require_relative '../../db/migration_helpers/risk_simplifier_helper'

class SimplifyIntimidationAtts < ActiveRecord::Migration[5.2]
  include RiskSimplifierHelper

  def up
    add_column :risks, :intimidation_prisoners, :string
    add_column :risks, :intimidation_prisoners_details, :text

    add_column :risks, :intimidation_public, :string
    add_column :risks, :intimidation_public_details, :text

    say_with_time 'Consolidating intimidation details into two groups' do
      risks = Risk.where(intimidation: 'yes')
      risks.each { |risk| risk.update_columns(simplify_intimidation_attributes(risk)) }
      risks.size
    end

    remove_column :risks, :intimidation

    remove_column :risks, :intimidation_to_other_detainees
    remove_column :risks, :intimidation_to_other_detainees_details

    remove_column :risks, :intimidation_to_public
    remove_column :risks, :intimidation_to_public_details

    remove_column :risks, :intimidation_to_witnesses
    remove_column :risks, :intimidation_to_witnesses_details
  end

  def down
    add_column :risks, :intimidation, :text

    add_column :risks, :intimidation_to_other_detainees, :boolean
    add_column :risks, :intimidation_to_other_detainees_details, :text

    add_column :risks, :intimidation_to_public, :boolean
    add_column :risks, :intimidation_to_public_details, :text

    add_column :risks, :intimidation_to_witnesses, :boolean
    add_column :risks, :intimidation_to_witnesses_details, :text

    say_with_time 'Expanding intimidation details into three groups' do
      risks = Risk.where("intimidation_prisoners = 'yes' OR intimidation_public = 'yes'")
      risks.each { |risk| risk.update_columns(complexify_intimidation_attributes(risk)) }
      risks.size
    end

    remove_column :risks, :intimidation_prisoners
    remove_column :risks, :intimidation_prisoners_details

    remove_column :risks, :intimidation_public
    remove_column :risks, :intimidation_public_details
  end
end
