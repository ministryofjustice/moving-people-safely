# frozen_string_literal: true

# rubocop:disable Metric/ClassLength
class BulkEscortGenerator
  PER_ESTABLISHMENT = 2
  MAX_OFFENCES = 7
  STATES = %i[editing cancelled issued reused].freeze

  def initialize
    @for_reuse = nil
  end

  def call(per_establishment: PER_ESTABLISHMENT, state: STATES.first, establishment:)
    raise "Unknown state #{state}, must be one of #{STATES.join(', ')}" unless STATES.include?(state)

    if establishment
      if state == :reused
        find_for_resuse(establishment.type)
        reuse(establishment, per_establishment)
      else
        generate(establishment, per_establishment, state)
      end
    else
      [Prison, PoliceCustody].each do |establishment_type|
        find_for_resuse(establishment_type.to_s) if state == :reused
        generate_for(establishment_type, per_establishment, state)
      end
    end
  end

  def purge
    Escort.joins(:detainee).where("detainees.surname LIKE 'Test-%'").delete_all
  end

  private

  def add_offences(escort, max = MAX_OFFENCES)
    (1..max).to_a.sample.times do
      escort.offences.create(
        offence: "#{Faker::Verb.past_participle.capitalize} #{Faker::Superhero.name} with #{Faker::DcComics.villain}",
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

  def find_for_resuse(establishment_type)
    if establishment_type == 'Prison'
      @for_reuse = Escort.uncancelled.from_prison
    elsif establishment_type == 'PoliceCustody'
      @for_reuse = Escort.uncancelled.from_police
    end

    puts "#{@for_reuse.count} #{establishment_type} escorts found for re-use."
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def generate(establishment, count, state)
    (1..count).each do |i|
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

      puts "Escort #{i}/#{count} (#{state}) created for #{establishment.name}: " \
           "#{escort.id} #{escort.detainee.forenames} #{escort.detainee.surname}"
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def generate_for(establishment_type, count, state)
    establishment_type.all.each do |establishment|
      state == :reused ? reuse(establishment, count) : generate(establishment, count, state)
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

  def move_attributes(establishment_id)
    {
      from_establishment_id: establishment_id,
      to: [Faker::Space.nebula, Faker::Nation.capital_city, Faker::Restaurant.name, Faker::Space.agency].sample,
      to_type: 'other',
      date: Date.current,
      not_for_release: 'no'
    }
  end

  def random_binary(hash, attribute, details = nil)
    if [true, true, false].sample
      hash[attribute] = 'no'
      return
    end

    hash[attribute] = 'yes'
    hash["#{attribute}_details".to_sym] = details || Faker::Lorem.sentence(12)
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

  def reuse(establishment, count)
    @for_reuse.limit(count).all.each_with_index do |existant_escort, i|
      escort = EscortCreator.call(
        existant_escort.attributes.with_indifferent_access,
        establishment
      )

      # Human fills in move
      escort.move.update(move_attributes(establishment.id))

      puts "Escort #{i + 1}/#{count} reused for #{establishment.name}: " \
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
