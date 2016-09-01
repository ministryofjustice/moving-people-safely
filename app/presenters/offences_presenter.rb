class OffencesPresenter < SimpleDelegator
  def styled_current_offences
    current_offences.offences.map { |o| o.fetch(:offence, []) }.join('<br>')
  end

  def styled_past_offences
    past_offences.offences.map { |o| o.fetch(:offence, []) }.join('<br>')
  end
end
