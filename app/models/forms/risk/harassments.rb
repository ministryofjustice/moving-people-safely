require 'risk'

module Forms
  module Risk
    class Harassments < Forms::Base
      optional_field :stalker_harasser_bully

      reset attributes: ::Risk.stalker_harasser_bully_all_values, if_falsey: :stalker_harasser_bully

      optional_checkbox :hostage_taker, :stalker_harasser_bully
      optional_checkbox :stalker, :stalker_harasser_bully
      optional_checkbox :harasser, :stalker_harasser_bully
      optional_checkbox :intimidator, :stalker_harasser_bully
      optional_checkbox :bully, :stalker_harasser_bully
    end
  end
end
