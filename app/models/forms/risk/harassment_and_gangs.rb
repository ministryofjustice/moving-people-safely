module Forms
  module Risk
    class HarassmentAndGangs < Forms::Base
      optional_details_field :intimidation_public
      optional_details_field :intimidation_prisoners
      optional_details_field :gang_member
    end
  end
end
