class SimplifyElistAtts < ActiveRecord::Migration[5.2]
  MAP = {
    'e_list_standard' => 'E-List standard',
    'e_list_escort' => 'E-List escort',
    'e_list_heightened' => 'E-List heightened'
  }.freeze

  def up
    say_with_time 'Simplifying e_list attribute' do
      risks = Risk.where(current_e_risk: 'yes')

      risks.each do |risk|
        risk.update_column(:current_e_risk_details, MAP[risk.current_e_risk_details])
      end

      risks.size
    end
  end

  def down
    say_with_time 'Complexifying e_list attribute' do
      risks = Risk.where(current_e_risk: 'yes')

      risks.each do |risk|
        risk.update_column(:current_e_risk_details, MAP.key(risk.current_e_risk_details))
      end

      risks.size
    end
  end
end
