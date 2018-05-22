module EscortsHelper
  def identifier(detainee)
    "#{detainee.prison_number}: #{detainee.surname}"
  end

  def ethnicity(detainee)
    if detainee.ethnicity.present?
      return 'White: British' if detainee.ethnicity == 'White: Eng./Welsh/Scot./N.Irish/British'
      detainee.ethnicity
    else
      'None'
    end
  end

  def date_of_birth(detainee)
    detainee.date_of_birth.to_s(:humanized)
  end

  def gender_code(detainee)
    detainee.gender == 'male' ? 'M' : 'F'
  end

  def short_ethnicity(detainee)
    return 'White: British' if detainee.ethnicity == 'White: Eng./Welsh/Scot./N.Irish/British'
    detainee.ethnicity
  end

  def aliases(detainee)
    return %w[None] unless detainee.aliases.present?
    detainee.aliases.split(',').map(&:strip)
  end

  def nationalities(detainee)
    return %w[None] unless detainee.nationalities.present?
    detainee.nationalities.split(',').map(&:strip)
  end

  def expanded_interpreter_required(detainee)
    return 'Not required' if detainee.interpreter_required == 'no'
    detainee.interpreter_required&.capitalize
  end

  def image(detainee)
    if detainee.image.present?
      image_tag("data:image;base64,#{detainee.image}")
    else
      wicked_pdf_image_tag('photo_unavailable.png')
    end
  end

  def date(move)
    move.date.to_s(:humanized)
  end

  def from(move)
    move.from_establishment&.name
  end

  def not_for_release_text(move)
    return 'Contact the prison to confirm release' if move.not_for_release == 'no'
    return move.not_for_release_reason_details.humanize if move.not_for_release_reason == 'other'
    move.not_for_release_reason.humanize
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
