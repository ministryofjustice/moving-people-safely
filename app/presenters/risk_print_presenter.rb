class RiskPrintPresenter < SimpleDelegator
  def initialize(risk, view_context)
    @view_context = view_context
    super(risk)
  end

  def risk_to_self_section
    summarize_section(:risk_to_self, {
      open_acct: 'yes',
      suicide: 'yes'
    })
  end

  def risk_from_others_section
    summarize_section(:risk_from_others, {
      rule_45: 'yes',
      csra: %w[ high standard ],
      verbal_abuse: 'yes',
      physical_abuse: 'yes'
    })
  end

  def violent_section
    summarize_section(:violent, {
      prison_staff: true,
      risk_to_females: true,
      escort_or_court_staff: true,
      healthcare_staff: true,
      other_detainees: true,
      homophobic: true,
      racist: true,
      public_offence_related: true,
      police: true
    })
  end

  def harassments_section
    summarize_section(:harassments, {
      hostage_taker: true,
      stalker: true,
      harasser: true,
      intimidator: true,
      bully: true
    })
  end

  def sex_offender_section
    # tricky
  end

  def non_association_markers_section

  end

  def summarize_section(key, fields)
    title = I18n.t("helpers.print.#{key}", default: key.to_s.humanize)
    details = fields.reduce('') { |memo, obj| memo + detail_row(obj[0], obj[1]).to_s }

    @view_context.render partial: 'summary', locals: { title: title, details: details }
  end

  def detail_row(field, on_attribute)
    matched_attribute = field_matches_attribute(field, on_attribute)
    if matched_attribute
      title = I18n.t("helpers.print.#{field}", default: field.to_s.humanize)
      attribute = humanize_attribute(matched_attribute)
      details = public_send("#{field}_details") if respond_to? "#{field}_details"
      @view_context.render partial: 'attribute', locals: { title: title, attribute: attribute, details: details }
    end
  end

  def humanize_attribute(attribute)
    if [true, false].include? attribute
      attribute ? 'Yes' : 'No'
    else
      attribute.to_s.humanize
    end
  end

  def field_matches_attribute(field, attribute)
    result = public_send(field)

    if attribute.is_a?(Array) && attribute.include?(result)
      result
    elsif result == attribute
      result
    end
  end
end
