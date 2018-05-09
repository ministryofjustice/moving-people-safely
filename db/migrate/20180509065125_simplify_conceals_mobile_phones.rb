require_relative '../../db/migration_helpers/risk_simplifier_helper'

class SimplifyConcealsMobilePhones < ActiveRecord::Migration[5.2]
  include RiskSimplifierHelper
  
  def up
    add_column :risks, :conceals_mobile_phone_or_other_items_details, :text

    say_with_time 'Simplifying conceals mobile phones' do
      risks = Risk.where(conceals_mobile_phone_or_other_items: 'yes')
      risks.each { |risk| risk.update_columns(simplify_conceals_mobile_phones(risk)) }
      risks.size
    end

    remove_column :risks, :conceals_mobile_phones
    remove_column :risks, :conceals_sim_cards
    remove_column :risks, :conceals_other_items
    remove_column :risks, :conceals_other_items_details
  end

  def down
    add_column :risks, :conceals_mobile_phones, :boolean
    add_column :risks, :conceals_sim_cards, :boolean
    add_column :risks, :conceals_other_items, :boolean
    add_column :risks, :conceals_other_items_details, :text

    say_with_time 'Complexifying conceals mobile phones' do
      risks = Risk.where(conceals_mobile_phone_or_other_items: 'yes')
      risks.each { |risk| risk.update_columns(complexify_conceals_mobile_phones(risk)) }
      risks.size
    end

    remove_column :risks, :conceals_mobile_phone_or_other_items_details
  end
end
