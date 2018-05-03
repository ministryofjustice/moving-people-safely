require_relative '../../db/migration_helpers/risk_simplifier_helper'

class SimplifyHostageTakerAtts < ActiveRecord::Migration[5.2]
  include RiskSimplifierHelper

  def up
    add_column :risks, :hostage_taker_details, :text

    say_with_time 'Simplifying hostage taker attributes' do
      risks = Risk.where(hostage_taker: 'yes')
      risks.each { |risk| risk.update_columns(simplify_hostage_taker_attributes(risk)) }
      risks.size
    end

    remove_column :risks, :staff_hostage_taker
    remove_column :risks, :date_most_recent_staff_hostage_taker_incident
    remove_column :risks, :prisoners_hostage_taker
    remove_column :risks, :date_most_recent_prisoners_hostage_taker_incident
    remove_column :risks, :public_hostage_taker
    remove_column :risks, :date_most_recent_public_hostage_taker_incident
  end

  def down
    add_column :risks, :staff_hostage_taker, :boolean
    add_column :risks, :date_most_recent_staff_hostage_taker_incident, :text
    add_column :risks, :prisoners_hostage_taker, :boolean
    add_column :risks, :date_most_recent_prisoners_hostage_taker_incident, :text
    add_column :risks, :public_hostage_taker, :boolean
    add_column :risks, :date_most_recent_public_hostage_taker_incident, :text

    say_with_time 'Complexifying hostage taker attributes' do
      risks = Risk.where(hostage_taker: 'yes')
      risks.each { |risk| risk.update_columns(complexify_hostage_taker_attributes(risk)) }
      risks.size
    end

    remove_column :risks, :hostage_taker_details
  end
end
