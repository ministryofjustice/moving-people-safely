module EscortsHelper
  def identifier(escort)
    "#{escort.number}: #{escort.surname}"
  end

  def age(date_of_birth)
    AgeCalculator.age(date_of_birth)
  end

  def ethnicity(ethnicity)
    if ethnicity.present?
      return 'White: British' if ethnicity == 'White: Eng./Welsh/Scot./N.Irish/British'
      ethnicity
    else
      'None'
    end
  end

  def gender_code(gender)
    gender == 'male' ? 'M' : 'F'
  end

  def aliases(escort)
    return %w[None] unless escort.aliases.present?
    escort.aliases.split(',').map(&:strip)
  end

  def nationalities(escort)
    return %w[None] unless escort.nationalities.present?
    escort.nationalities.split(',').map(&:strip)
  end

  def expanded_interpreter_required(interpreter_required)
    return 'Not required' if interpreter_required == 'no'
    interpreter_required&.capitalize
  end

  def image(image)
    if image.present?
      image_tag("data:image;base64,#{image}")
    else
      wicked_pdf_image_tag('photo_unavailable.png')
    end
  end

  def not_for_release_text(escort)
    return 'Contact the prison to confirm release' if escort.not_for_release == 'no'
    return escort.not_for_release_reason_details.humanize if escort.not_for_release_reason == 'other'
    escort.not_for_release_reason.humanize
  end

  def offences_label(offences)
    content = t('print.label.offences.current_offences')
    offences.any? ? highlighted_content(content) : content
  end

  def offences_relevant(offences)
    offences.any? ? highlighted_content('Yes') : 'None'
  end

  def formatted_offences_list(offences)
    return if offences.empty?
    safe_join(offences.map do |item|
      array = [item.offence]
      array << "(#{item.case_reference})" if item.respond_to?(:case_reference) && item.case_reference.present?
      array.join(' ')
    end, ' | ')
  end

  def acct_status_text(risk)
    case risk.acct_status
    when 'closed'
      "Closed: #{risk.date_of_most_recently_closed_acct}"
    when 'none', nil
      nil
    else
      risk.acct_status.humanize
    end
  end

  def acct_details(risk)
    "Closed on #{risk.date_of_most_recently_closed_acct} | #{risk.acct_status_details}" if risk.acct_status == 'closed'
  end

  def must_return_details(risk)
    answer_details(risk.must_return_to, risk.must_return_to_details)
  end
end
