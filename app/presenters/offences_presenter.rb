class OffencesPresenter < SimpleDelegator
  def styled_current_offences
    current_offences.map(&:offence).join('<br>')
  end

  def styled_past_offences
    past_offences.map(&:offence).join('<br>')
  end
end
