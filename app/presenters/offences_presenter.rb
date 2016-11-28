class OffencesPresenter < SimpleDelegator
  attr_reader :current_offences

  def initialize(offences)
    @current_offences = offences.current_offences.map { |offence| CurrentOffencePresenter.new(offence) }
    super
  end
end
