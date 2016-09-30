require 'rails_helper'

RSpec.describe Considerations::FormFactory do
  subject { described_class.new(detainee) }
  let(:detainee) { create(:detainee) }

  describe "#call" do
    let(:name_mappings) do
      {
        allergies: %w[ allergies ],
        arson: %w[ arson damage_to_property ],
        communication: %w[ interpreter_required hearing_speach_sight can_read_and_write ],
        concealed_weapons: %w[ conceals_weapons ],
        harassments: %w[ harassment ],
        healthcare_needs: %w[ dependencies medications ],
        mental_healthcare: %w[ mental_illness phobias ],
        non_association_markers: %w[ non_association_markers ],
        medical_contact: %w[ clinician ],
        physical_issues: %w[ physical_issues ],
        risk_from_others: %w[ rule_45 verbal_abuse physical_abuse csra ],
        risk_to_self: %w[ open_acct suicide ],
        transport: %w[ mpv ],
        security: %w[ current_e_risk category_a restricted_status ],
        sex_offences: %w[ sex_offence ],
        social_healthcare: %w[ personal_hygiene personal_care ],
        substance_misuse: %w[ substance_supply substance_use ],
        violence: %w[ violence ]
      }
    end

    let(:class_mappings) do
      {
        allergies: Considerations::OptionalDetails,
        arson: Considerations::Arson,
        can_read_and_write: Considerations::OptionalDetails,
        category_a: Considerations::OptionalDetails,
        clinician: Considerations::Clinician,
        conceals_weapons: Considerations::OptionalDetails,
        csra: Considerations::Csra,
        current_offences: Considerations::CurrentOffences,
        damage_to_property: Considerations::OptionalDetails,
        dependencies: Considerations::OptionalDetails,
        current_e_risk: Considerations::EscapeRisk,
        harassment: Considerations::Harassment,
        hearing_speach_sight: Considerations::OptionalDetails,
        interpreter_required: Considerations::InterpreterRequired,
        medications: Considerations::Medications,
        mental_illness: Considerations::OptionalDetails,
        mpv: Considerations::OptionalDetails,
        non_association_markers: Considerations::OptionalDetails,
        open_acct: Considerations::OpenAcct,
        personal_care: Considerations::OptionalDetails,
        personal_hygiene: Considerations::OptionalDetails,
        phobias: Considerations::OptionalDetails,
        physical_abuse: Considerations::OptionalDetails,
        physical_issues: Considerations::OptionalDetails,
        restricted_status: Considerations::OptionalDetails,
        rule_45: Considerations::OptionalDetails,
        sex_offence: Considerations::SexOffence,
        substance_supply: Considerations::OptionalDetails,
        substance_use: Considerations::OptionalDetails,
        suicide: Considerations::OptionalDetails,
        verbal_abuse: Considerations::OptionalDetails,
        violence: Considerations::Violence
      }
    end

    it "returns the correctly configured form instance" do
      name_mappings.each do |form, name_mapping|
        result = subject.(form)
        result.models.each do |consideration|
          expect(name_mapping).to include consideration.name
          expect(consideration.class.name).to eql class_mappings.fetch(consideration.name.to_sym).name
        end
      end
    end
  end
end
