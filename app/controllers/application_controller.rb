class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :offences,
    :risk,
    :healthcare,
    :detainee,
    :active_move,
    :healthcare_workflow,
    :risk_workflow,
    :offences_workflow

  delegate :risk, :healthcare, :offences, :active_move, to: :detainee
  delegate :healthcare_workflow, :risk_workflow, :offences_workflow, to: :active_move

  private

  def redirect_unless_document_editable
    unless AccessPolicy.edit?(move: active_move)
      redirect_back(fallback_location: root_path)
    end
  end

  LENNIE_GODBER = 'A1111AA'
  PETER_SMITH = 'B2222BB'

  # dummy data for user testing
  def attributes_for_lennie_godber
    {
      forenames: 'Lennie',
      surname: 'Godber',
      date_of_birth: '06/07/1947',
      gender: 'male',
      nationalities: 'English',
      pnc_number: 'CD23456F',
      cro_number: 'AB12345D',
      aliases: 'Richard Arthur Beckinsale',
      prison_number: "Z#{rand.to_s[2..5]}ZZ",
      image_filename: 'lennie_godber.jpg'
    }
  end

  def create_peter_smith
    detainee = Detainee.create({
      forenames: 'Peter',
      surname: 'Smith',
      date_of_birth: '12/12/1977',
      gender: 'male',
      nationalities: 'British, Irish',
      pnc_number: '123/456',
      cro_number: '456/123',
      aliases: 'Paul Gold',
      prison_number: "Z#{rand.to_s[2..5]}ZZ",
      image_filename: 'peter_smith.jpg'
    })
    detainee.moves << Move.create({
      from: 'HMP Bedford',
      to: 'St Albans Crown Court',
      date: Date.new(2016, 8, 11),
      reason: 'production_to_court',
      has_destinations: 'no'
    })
    detainee.risk = Risk.create({
      open_acct: 'no',
      suicide: 'no',
      rule_45: 'no',
      csra: 'standard',
      verbal_abuse: 'no',
      physical_abuse: 'no',
      violent: 'yes',
      prison_staff: 'no',
      risk_to_females: 'no',
      escort_or_court_staff: 'no',
      healthcare_staff: 'no',
      other_detainees: 'no',
      homophobic: 'no',
      racist: 'no',
      public_offence_related: 'no',
      police: 'yes',
      police_details: 'Violently resisting arrest. Used bladed item.',
      stalker_harasser_bully: 'yes',
      hostage_taker: 'no',
      stalker: 'no',
      harasser: 'no',
      intimidator: 'yes',
      intimidator_details: 'History of intimidating police officers',
      bully: 'no',
      sex_offence: 'no',
      non_association_markers: 'no',
      current_e_risk: 'no',
      category_a: 'no',
      restricted_status: 'no',
      escape_pack: false,
      escape_risk_assessment: false,
      cuffing_protocol: true,
      substance_supply: 'no',
      substance_use: 'yes',
      substance_use_details: 'Heroin',
      conceals_weapons: 'no',
      arson: 'yes',
      arson_details: 'Secreted lighter found during last escort',
      arson_value: 'behavioural_issue',
      damage_to_property: 'yes',
      damage_to_property_details: 'Damage to police custody cell and prison reception holding cell',
      interpreter_required: 'no',
      hearing_speach_sight: 'no',
      can_read_and_write: 'no'
    })
    detainee.healthcare = Healthcare.create({
      physical_issues: 'no',
      mental_illness: 'yes',
      mental_illness_details: 'Depression. Victim old vulnarable couple.',
      phobias: 'no',
      personal_hygiene: 'no',
      personal_care: 'no',
      allergies: 'no',
      dependencies: 'no',
      has_medications: 'yes',
      mpv: 'no',
      healthcare_professional: 'Walker Marquardt',
      contact_number: '(205) 562-0855'
    })
    detainee.healthcare.medications << Medication.create({
      description: 'Paracetamol',
      administration: '400mg every 4 hours',
      carrier: 'escort'
    })
    detainee.offences = Offences.create({
      release_date: Date.new(2019, 06, 12),
      not_for_release: true,
      not_for_release_details: 'Serving sentence',
      has_past_offences: "no"
    })
    detainee.offences.current_offences << CurrentOffence.create({
      offence: 'Aggravated burglary',
      case_reference: 'XXX'
    })
    detainee.active_move.risk_workflow.confirmed!
    detainee.active_move.healthcare_workflow.confirmed!
    detainee.active_move.offences_workflow.confirmed!
    detainee.active_move.workflow.issued!
    detainee
  end
end
