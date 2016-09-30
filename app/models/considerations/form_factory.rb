module Considerations
  class FormFactory
    def initialize(detainee)
      @detainee = detainee
    end

    def call(form_name)
      @name = form_name
      configure_form_with models_for(@name)
    end

    private
    attr_reader :detainee

    def configure_form_with(model_instances)
      CollectionProxy.new(@name, model_instances)
    end

    def models_for(form_name)
      form_models(form_name).map do |name|
        consideration_class(name).find_or_build(detainee: detainee, name: name)
      end
    end

    RISK_FORMS =
      {
        arson: %i[ arson damage_to_property ],
        communication: %i[ interpreter_required hearing_speach_sight can_read_and_write ],
        concealed_weapons: %i[ conceals_weapons ],
        harassments: %i[ harassment ],
        non_association_markers: %i[ non_association_markers ],
        risk_from_others: %i[ rule_45 csra verbal_abuse physical_abuse ],
        risk_to_self: %i[ open_acct suicide ],
        security: %i[ current_e_risk category_a restricted_status ],
        sex_offences: %i[ sex_offence ],
        substance_misuse: %i[ substance_supply substance_use ],
        violence: %i[ violence ]
      }

    HEALTH_FORMS =
      {
        allergies: %i[ allergies ],
        healthcare_needs: %i[ dependencies medications ],
        mental_healthcare: %i[ mental_illness phobias ],
        medical_contact: %i[ clinician ],
        physical_issues: %i[ physical_issues ],
        transport: %i[ mpv ],
        social_healthcare: %i[ personal_hygiene personal_care ]
      }

    OFFENCES_FORMS = { offences: %i[ release_date not_for_release current_offences past_offences ]}

    def form_models(form_name)
      case form_name
      when :risk
        RISK_FORMS.values.flatten
      when :healthcare
        HEALTH_FORMS.values.flatten
      when :offences
        OFFENCES_FORMS.values.flatten
      else
        RISK_FORMS.merge(HEALTH_FORMS).merge(OFFENCES_FORMS).fetch(form_name)
      end
    end

    def consideration_class(consideration_name)
      {
        allergies: OptionalDetails,
        arson: Arson,
        can_read_and_write: OptionalDetails,
        category_a: OptionalDetails,
        clinician: Clinician,
        conceals_weapons: OptionalDetails,
        csra: Csra,
        current_offences: CurrentOffences,
        damage_to_property: OptionalDetails,
        dependencies: OptionalDetails,
        current_e_risk: EscapeRisk,
        harassment: Harassment,
        hearing_speach_sight: OptionalDetails,
        interpreter_required: InterpreterRequired,
        medications: Medications,
        mental_illness: OptionalDetails,
        mpv: OptionalDetails,
        non_association_markers: OptionalDetails,
        not_for_release: NotForRelease,
        open_acct: OpenAcct,
        past_offences: PastOffences,
        personal_care: OptionalDetails,
        personal_hygiene: OptionalDetails,
        phobias: OptionalDetails,
        physical_abuse: OptionalDetails,
        physical_issues: OptionalDetails,
        release_date: DateField,
        restricted_status: OptionalDetails,
        rule_45: OptionalDetails,
        sex_offence: SexOffence,
        substance_supply: OptionalDetails,
        substance_use: OptionalDetails,
        suicide: OptionalDetails,
        verbal_abuse: OptionalDetails,
        violence: Violence
      }.fetch(consideration_name)
    end
  end
end
