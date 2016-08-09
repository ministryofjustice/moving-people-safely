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

  #private

  def redirect_unless_document_editable
    unless AccessPolicy.edit?(move: active_move)
      redirect_back(fallback_location: root_path)
    end
  end

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
      prison_number: "Z#{rand.to_s[2..5]}ZZ"
    }
  end

  def create_lennie_godber_with_completed_move
    lennie = Detainee.create(attributes_for_lennie_godber)
    lennie.risk = Risk.create({
      open_acct: 'no',
      suicide: 'no',
      rule_45: 'no',
      csra: 'standard',
      verbal_abuse: 'no',
      physical_abuse: 'no',
      violent: 'no',
      stalker_harasser_bully: 'no',
      sex_offence: 'no',
      non_association_markers: 'no',
      current_e_risk: 'no',
      escape_list: 'no',
      other_escape_risk_info: 'no',
      category_a: 'no',
      restricted_status: 'no',
      escape_pack: false,
      escape_risk_assessment: false,
      cuffing_protocol: false,
      drugs: 'no',
      alcohol: 'no',
      conceals_weapons: 'no',
      arson: 'no',
      damage_to_property: 'no',
      interpreter_required: 'no',
      hearing_speach_sight: 'no',
      can_read_and_write: 'no'
    })
    lennie.healthcare = Healthcare.create({
      physical_issues: 'no',
      mental_illness: 'no',
      phobias: 'no',
      personal_hygiene: 'no',
      personal_care: 'no',
      allergies: 'no',
      dependencies: 'no',
      has_medications: 'no',
      healthcare_professional: 'Walker Marquardt',
      contact_number: '(205) 562-0855'
    })
    lennie.offences = Offences.create({
      release_date: Date.new(2019, 06, 12),
      not_for_release: true,
      not_for_release_details: 'Serving sentence',
      has_past_offences: "no"
    })
  end
end
