class OffencesPresenter < SimpleDelegator
  def styled_current_offences
    current_offences.map(&:offence).join('<br>').html_safe
  end

  def styled_past_offences
    past_offences.map(&:offence).join('<br>').html_safe
  end
end
