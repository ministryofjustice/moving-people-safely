# frozen_string_literal: true

# rubocop:disable Metric/ClassLength
class BulkEscortGenerator
  PER_ESTABLISHMENT = 2
  MAX_OFFENCES = 7
  START_DATE = Date.today
  PERIOD = 1
  STATES = %i[editing cancelled issued reused].freeze

  attr_reader :per_establishment, :state, :establishment, :destination, :start_date, :period

  def initialize(per_establishment: PER_ESTABLISHMENT, state: STATES.first,
    establishment: nil, destination: nil, start_date: START_DATE, period: PERIOD)
    raise "Unknown state #{state}, must be one of #{STATES.join(', ')}" unless STATES.include?(state)

    @per_establishment = per_establishment
    @state = state
    @establishment = establishment
    @destination = destination
    @start_date = start_date
    @period = period
    @log = []
  end

  def call
    if establishment
      if state == :reused
        find_for_reuse(establishment.type)
        reuse(establishment)
      else
        generate(establishment)
      end
    else
      [Prison, PoliceCustody].each do |establishment_type|
        find_for_reuse(establishment_type.to_s) if state == :reused
        generate_for(establishment_type)
      end
    end

    puts "\nSUMMARY:\n#{@log.join("\n")}"
  end

  def purge
    Escort.joins(:detainee).where("detainees.surname LIKE 'Test-%'").delete_all
  end

  private

  def add_offences(escort)
    (1..MAX_OFFENCES).to_a.sample.times do
      escort.offences.create(
        offence: random_offence,
        case_reference: Faker::Lorem.characters(12).upcase,
        detainee_id: escort.detainee.id
      )
    end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def detainee_attributes(search)
    {
      prison_number: search[:prison_number],
      pnc_number: search[:pnc_number],
      forenames: Faker::Name.first_name,
      surname: "Test-#{Faker::Name.last_name}",
      date_of_birth: Faker::Date.between(80.years.ago, 20.years.ago),
      gender: (Array.new(19) { 'male' } + %w[female]).sample, # To get a realistic M/F proportion (4.6% female in UK)
      nationalities: Faker::Nation.nationality,
      cro_number: rand(9999),
      aliases: Faker::FunnyName.name,
      interpreter_required: 'yes',
      interpreter_required_details: Faker::Lorem.sentence(3),
      peep: 'yes',
      peep_details: Faker::Lorem.sentence(5),
      security_category: 'Cat A',
      diet: (Array.new(5) { '' } + %w[gluten_free vegan vegetarian]).sample.humanize,
      language: Faker::Nation.language
    }
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def find_for_reuse(establishment_type)
    if establishment_type == 'Prison'
      @for_reuse = Escort.uncancelled.from_prison
    elsif establishment_type == 'PoliceCustody'
      @for_reuse = Escort.uncancelled.from_police
    end

    @log << "#{@for_reuse.count} #{establishment_type} escorts found for re-use."
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def generate(establishment)
    (1..per_establishment).each do |i|
      search = {
        prison_number: establishment.type == 'Prison' ? random_prison_number : nil,
        pnc_number: establishment.type == 'PoliceCustody' ? random_pnc_number : nil
      }

      escort = EscortCreator.call(search, establishment)

      # The bits the human would fill in
      escort.create_detainee(detainee_attributes(search))
      escort.move.update(move_attributes(establishment.id))
      add_offences(escort)
      escort.create_offences_workflow
      escort.create_risk(risk_attributes)
      escort.create_healthcare(healthcare_attributes)

      escort = issue(escort, establishment) if state == :issued
      escort.cancel!(user, Faker::Lorem.sentence(15)) if state == :cancelled

      @log << "Escort #{i}/#{per_establishment} (#{state}) created for #{establishment.name}: " \
           "#{escort.id} #{escort.detainee.forenames} #{escort.detainee.surname}"
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def generate_for(establishment_type)
    establishment_type.all.each do |establishment|
      state == :reused ? reuse(establishment) : generate(establishment)
    end
  end

  def healthcare_attributes
    {
      has_medications: 'no',
      contact_number: Faker::PhoneNumber.phone_number
    }.tap do |atts|
      %i[ physical_issues mental_illness personal_care dependencies mpv pregnant
          alcohol_withdrawal female_hygiene_kit ].each { |attribute| random_binary(atts, attribute) }

      random_binary(atts, :allergies, Array.new(3) { Faker::Food.ingredient } .join(', '))
    end
  end

  def issue(escort, establishment)
    escort.offences_workflow.confirm!(user: user)
    escort.risk.confirm!(user: user)
    escort.healthcare.confirm!(user: user)
    escort.approve!(user) if establishment.type == 'PoliceCustody'
    EscortIssuer.call(escort)
    escort.reload
  end

  def move_attributes(from_establishment_id)
    {
      from_establishment_id: from_establishment_id,
      date: START_DATE + ((1..period).to_a.sample - 1),
      not_for_release: 'no'
    }.tap do |atts|
      if destination
        atts.merge!(to: destination.name, to_type: destination.type.underscore)
      else
        atts.merge!(to: random_destination, to_type: 'other')
      end
    end
  end

  def random_binary(hash, attribute, details = nil)
    if [true, true, false].sample
      hash[attribute] = 'no'
      return
    end

    hash[attribute] = 'yes'
    hash["#{attribute}_details".to_sym] = details || Faker::Lorem.sentence(12)
  end

  def random_character
    [
      [Faker::Military.army_rank, 'Professor', 'Reverand', 'Inspector', nil, nil, nil, nil].sample,
      [Faker::Superhero.name, Faker::Artist.name, Faker::DcComics.hero,
       Faker::GreekPhilosophers.name, Faker::Science.scientist].sample,
      ['OBE', '(Miss)', "(#{Faker::Food.vegetables} expert)", 'BSc', nil, nil, nil].sample
    ].compact.join(' ')
  end

  def random_destination
    [
      Faker::Space.nebula,
      Faker::Nation.capital_city,
      Faker::Restaurant.name,
      Faker::Space.agency,
      Faker::Bank.name,
      Faker::University.name
    ].sample
  end

  def random_offence
    [
      Faker::Verb.past_participle.capitalize,
      random_character,
      ['with a', 'by means of a', 'using a'].sample,
      [Faker::Food.dish, Faker::Beer.name].sample
    ].join(' ')
  end

  def random_pnc_number
    [
      format('%02d', rand(99)),
      '/',
      format('%06d', rand(999_999)),
      ('A'..'Z').to_a.sample
    ].join
  end

  def random_prison_number
    b = Array.new(4) { (0..9).to_a.sample }
    ['Z', b[0], b[1], b[2], b[3], 'ZZ'].join
  end

  def reuse(establishment)
    @for_reuse.limit(per_establishment).all.each_with_index do |existant_escort, i|
      escort = EscortCreator.call(
        existant_escort.attributes.with_indifferent_access,
        establishment
      )

      # Human fills in move & offences
      escort.move.update(move_attributes(establishment.id))
      add_offences(escort)

      @log << "Escort #{i + 1}/#{per_establishment} reused for #{establishment.name}: " \
           "#{escort.id} #{escort.detainee.forenames} #{escort.detainee.surname}"
    end
  end

  def risk_attributes
    { acct_status: 'open', observation_level: 'level1', csra: 'standard',
      escape_pack: 'no', escort_risk_assessment: 'no', arson: 'no' }.tap do |atts|
      %i[ risk_to_females homophobic racist current_e_risk conceals_weapons high_profile
          other_violence_due_to_discrimination gang_member conceals_drugs controlled_unlock
          other_risk uses_weapons discrimination_to_other_religions violence_to_staff
          must_return_to previous_escape_attempts self_harm vulnerable_prisoner
          pnc_warnings intimidation_prisoners intimidation_public hostage_taker
          sex_offence conceals_mobile_phone_or_other_items violent_or_dangerous substance_supply
          rule_45 ].each { |attribute| random_binary(atts, attribute) }
    end
  end

  def user
    @user ||= User.first
  end
end
# rubocop:enable Metric/ClassLength
