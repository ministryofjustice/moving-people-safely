module Forms
  module Risk
    class HarassmentAndGangs < Forms::Base
      options_field_with_details :intimidation_public
      options_field_with_details :intimidation_prisoners, if: :from_prison?
      options_field_with_details :gang_member
    end
  end
end
