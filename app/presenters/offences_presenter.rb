class OffencesPresenter < SimpleDelegator
  attr_reader :current_offences

  def initialize(offences)
    @current_offences = offences.map { |offence| CurrentOffencePresenter.new(offence) }
    super
  end

  def all_questions_answered?
    @current_offences.any?
  end
end
