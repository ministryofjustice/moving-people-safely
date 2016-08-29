class Risk < ApplicationRecord
  belongs_to :detainee
  include Questionable
  include Considerable

  def question_fields
    self.class.considerations
  end

  def self.csra_and_details_type_options(_field)
    {
      values: %w[ high standard unknown ],
      on_values: %w[ high ],
      child_fields: [ details_field(:csra_details) ]
    }
  end

  def self.sex_offence_victim_type_options(_field)
    {
      values: %w[adult_male adult_female under_18],
      on_values: %w[ under_18 ],
      child_fields: [ details_field(:sex_offence_details) ]
    }
  end

  consideration :damage_to_property, type: :ternary_and_details_field
  consideration :non_association_markers, type: :ternary_and_details_field
  consideration :open_acct, type: :ternary
  consideration :suicide, type: :ternary_and_details_field
  consideration :rule_45, type: :ternary_and_details_field
  consideration :csra, type: :csra_and_details
  consideration :verbal_abuse, type: :ternary_and_details_field
  consideration :physical_abuse, type: :ternary_and_details_field
  consideration :current_e_risk, type: :ternary_and_details_field
  consideration :category_a, type: :ternary_and_details_field
  consideration :restricted_status, type: :ternary_and_details_field
  consideration :substance_supply, type: :ternary_and_details_field
  consideration :substance_use, type: :ternary_and_details_field
  consideration :conceals_weapons, type: :ternary_and_details_field
  consideration :hearing_speach_sight, type: :ternary_and_details_field
  consideration :can_read_and_write, type: :ternary_and_details_field

  consideration :stalker_harasser_bully, type: :ternary, child_fields: [
    boolean_and_details_field(:hostage_taker),
    boolean_and_details_field(:stalker),
    boolean_and_details_field(:harasser),
    boolean_and_details_field(:intimidator),
    boolean_and_details_field(:bully)
  ]

  consideration :violent, type: :ternary, child_fields: [
    boolean_and_details_field(:prison_staff),
    boolean_and_details_field(:risk_to_females),
    boolean_and_details_field(:escort_or_court_staff),
    boolean_and_details_field(:healthcare_staff),
    boolean_and_details_field(:other_detainees),
    boolean_and_details_field(:homophobic),
    boolean_and_details_field(:racist),
    boolean_and_details_field(:public_offence_related),
    boolean_and_details_field(:police)
  ]

  consideration :sex_offence, type: :ternary, child_fields: [
    values_and_details_field(:sex_offence_victim, type: :sex_offence_victim)
  ]

  consideration :interpreter_required, type: :ternary, child_fields: [
    details_field(:language)
  ]

  consideration :arson, type: :ternary, child_fields: [
    details_field(:arson_value, values: %w[ index_offence behavioural_issue small_risk ]),
    details_field(:arson_details)
  ]
end
