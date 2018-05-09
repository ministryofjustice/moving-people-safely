module RiskSimplifierHelper
  SEPARATOR = ' | '.freeze

  # Intimidator
  INTIMIDATES_PUBLIC_PREFIX = 'Intimidates the public:'.freeze
  INTIMIDATES_WITNESS_PREFIX = 'Intimidates witnesses:'.freeze

  def simplify_intimidation_attributes(risk)
    return nil unless risk.intimidation == 'yes'

    # Intimidates prisoners
    if risk.intimidation_to_other_detainees
      intimidation_prisoners = 'yes'
      intimidation_prisoners_details = risk.intimidation_to_other_detainees_details
    else
      intimidation_prisoners = 'no'
      intimidation_prisoners_details = nil
    end

    # Intimidates public and/or witnesses
    public_details = []

    if risk.intimidation_to_witnesses
      public_details << "#{INTIMIDATES_WITNESS_PREFIX} #{risk.intimidation_to_witnesses_details}"
    end

    if risk.intimidation_to_public
      public_details << "#{INTIMIDATES_PUBLIC_PREFIX} #{risk.intimidation_to_public_details}"
    end

    if public_details.any?
      intimidation_public = 'yes'
      intimidation_public_details = public_details.join(SEPARATOR)
    else
      intimidation_public = 'no'
      intimidation_public_details = nil
    end

    {
      intimidation_prisoners: intimidation_prisoners,
      intimidation_prisoners_details: intimidation_prisoners_details,
      intimidation_public: intimidation_public,
      intimidation_public_details: intimidation_public_details
    }
  end

  def complexify_intimidation_attributes(risk)
    return nil if risk.intimidation_prisoners == 'no' && risk.intimidation_public == 'no'

    # Intimidates prisoners
    if risk.intimidation_prisoners == 'yes'
      to_other_detainees = true
      to_other_detainees_details = risk.intimidation_prisoners_details
    else
      to_other_detainees = false
      to_other_detainees_details = nil
    end

    # Intimidates public
    to_witnesses = false
    to_witnesses_details = nil
    to_public = false
    to_public_details = nil

    if risk.intimidation_public == 'yes'
      risk.intimidation_public_details.split(SEPARATOR).each do |details_with_label|
        case details_with_label
        when /^#{INTIMIDATES_WITNESS_PREFIX} (.+)$/
          to_witnesses = true
          to_witnesses_details = $1
        when /^#{INTIMIDATES_PUBLIC_PREFIX} (.+)$/
          to_public = true
          to_public_details = $1
        end
      end
    end

    {
      intimidation: 'yes',
      intimidation_to_other_detainees: to_other_detainees,
      intimidation_to_other_detainees_details: to_other_detainees_details,
      intimidation_to_witnesses: to_witnesses,
      intimidation_to_witnesses_details: to_witnesses_details,
      intimidation_to_public: to_public,
      intimidation_to_public_details: to_public_details
    }
  end

  # Hostage taker
  STAFF_HOSTAGE_PREFIX = 'Takes staff hostages. Most recent date:'.freeze
  PRISONERS_HOSTAGE_PREFIX = 'Takes prisoner hostages. Most recent date:'.freeze
  PUBLIC_HOSTAGE_PREFIX = 'Takes public hostages. Most recent date:'.freeze

  def simplify_hostage_taker_attributes(risk)
    return nil unless risk.hostage_taker == 'yes'
    details = []

    # Takes staff hostages
    if risk.staff_hostage_taker
      details << "#{STAFF_HOSTAGE_PREFIX} #{risk.date_most_recent_staff_hostage_taker_incident}"
    end

    # Takes prisoner hostages
    if risk.prisoners_hostage_taker
      details << "#{PRISONERS_HOSTAGE_PREFIX} #{risk.date_most_recent_prisoners_hostage_taker_incident}"
    end

    # Takes public hostages
    if risk.public_hostage_taker
      details << "#{PUBLIC_HOSTAGE_PREFIX} #{risk.date_most_recent_public_hostage_taker_incident}"
    end

    { hostage_taker_details: details.join(SEPARATOR) }
  end

  def complexify_hostage_taker_attributes(risk)
    return nil if risk.hostage_taker == 'no'

    takes_staff = false
    last_staff_date = nil
    takes_prisoners = false
    last_prisoners_date = nil
    takes_public = false
    last_public_date = nil

    risk.hostage_taker_details.split(SEPARATOR).each do |details_with_label|
      case details_with_label
      when /^#{STAFF_HOSTAGE_PREFIX} (.+)$/
        takes_staff = true
        last_staff_date = $1
      when /^#{PRISONERS_HOSTAGE_PREFIX} (.+)$/
        takes_prisoners = true
        last_prisoners_date = $1
      when /^#{PUBLIC_HOSTAGE_PREFIX} (.+)$/
        takes_public = true
        last_public_date = $1
      end
    end

    {
      staff_hostage_taker: takes_staff,
      date_most_recent_staff_hostage_taker_incident: last_staff_date,
      prisoners_hostage_taker: takes_prisoners,
      date_most_recent_prisoners_hostage_taker_incident: last_prisoners_date,
      public_hostage_taker: takes_public,
      date_most_recent_public_hostage_taker_incident: last_public_date
    }
  end

  # Sex offender
  SEX_MALE_PREFIX = 'Sex offences against males. Most recent date:'.freeze
  SEX_FEMALE_PREFIX = 'Sex offences against females. Most recent date:'.freeze
  SEX_UNDER18_PREFIX = 'Sex offences against under 18s. Most recent date:'.freeze

  def simplify_sex_offender_attributes(risk)
    return nil unless risk.sex_offence == 'yes'
    details = []

    # Males
    if risk.sex_offence_adult_male_victim
      details << "#{SEX_MALE_PREFIX} #{risk.date_most_recent_sexual_offence}"
    end

    # Females
    if risk.sex_offence_adult_female_victim
      details << "#{SEX_FEMALE_PREFIX} #{risk.date_most_recent_sexual_offence}"
    end

    # Under 18s
    if risk.sex_offence_under18_victim
      details << "#{SEX_UNDER18_PREFIX} #{risk.date_most_recent_sexual_offence}"
    end

    { sex_offences_details: details.join(SEPARATOR) }
  end

  def complexify_sex_offender_attributes(risk)
    return nil unless risk.sex_offence == 'yes'

    male = false
    female = false
    under18 = false
    last_date = nil

    risk.sex_offences_details.split(SEPARATOR).each do |details_with_label|
      case details_with_label
      when /^#{SEX_MALE_PREFIX} (.+)$/
        male = true
        last_date = $1
      when /^#{SEX_FEMALE_PREFIX} (.+)$/
        female = true
        last_date = $1
      when /^#{SEX_UNDER18_PREFIX} (.+)$/
        under18 = true
        last_date = $1
      end
    end

    {
      sex_offence_adult_male_victim: male,
      sex_offence_adult_female_victim: female,
      sex_offence_under18_victim: under18,
      date_most_recent_sexual_offence: last_date
    }
  end

  # Conceals mobile phones or other items
  CONCEALS_MOBILE_PHONES_TEXT = 'Conceals mobile phones'.freeze
  CONCEALS_SIM_CARDS_TEXT = 'Conceals SIM cards'.freeze
  CONCEALS_OTHER_PREFIX = 'Conceals other items:'.freeze

  def simplify_conceals_mobile_phones(risk)
    return nil unless risk.conceals_mobile_phone_or_other_items == 'yes'
    details = []

    details << CONCEALS_MOBILE_PHONES_TEXT if risk.conceals_mobile_phones
    details << CONCEALS_SIM_CARDS_TEXT if risk.conceals_sim_cards

    if risk.conceals_other_items
      details << "#{CONCEALS_OTHER_PREFIX} #{risk.conceals_other_items_details}"
    end

    { conceals_mobile_phone_or_other_items_details: details.join(SEPARATOR) }
  end

  def complexify_conceals_mobile_phones(risk)
    return nil unless risk.conceals_mobile_phone_or_other_items == 'yes'

    mobile_phones = false
    sim_cards = false
    other = false
    new_details = nil

    risk.conceals_mobile_phone_or_other_items_details.split(SEPARATOR).each do |details|
      case details
      when /^#{CONCEALS_MOBILE_PHONES_TEXT}$/
        mobile_phones = true
      when /^#{CONCEALS_SIM_CARDS_TEXT}$/
        sim_cards = true
      when /^#{CONCEALS_OTHER_PREFIX} (.+)$/
        other = true
        new_details = $1
      end
    end

    {
      conceals_mobile_phones: mobile_phones,
      conceals_sim_cards: sim_cards,
      conceals_other_items: other,
      conceals_other_items_details: new_details
    }
  end
end
