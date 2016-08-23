class RiskPrintPresenter < SimpleDelegator
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
    detail_rows = fields.reduce('') { |memo, obj| memo + detail_row(obj[0], obj[1]).to_s }
    title = I18n.t("helpers.print.#{key}", default: key.to_s.humanize)
    is_detail = detail_rows ? 'Yes' : 'No'

    out = "<tr>"
    out += "<th colspan='2'>#{title}</th>"
    out += "<td>#{is_detail}</td>"
    out += "<td></td>"
    out += detail_rows.to_s
    out.html_safe
  end

  def detail_row(field, on_attribute)
    matched_attribute = field_matches_attribute(field, on_attribute)
    if matched_attribute
      title = I18n.t("helpers.print.#{field}", default: field.to_s.humanize)
      out = "<tr>"
      out += "<td class='spacer'></td><th class='subhead'>#{title}</th>"
      out += "<td>#{humanize_attribute(matched_attribute)}</td>"

      if respond_to? "#{field}_details"
        details = public_send("#{field}_details")
      end

      out += "<td>#{details}</td>"
      out += "</tr>"
      out
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
