class OffencesPresenter < SimpleDelegator
  attr_reader :offences

  def initialize(offences)
    @offences = offences.map { |offence| CurrentOffencePresenter.new(offence) }
    super
  end

  def all_questions_answered?
    offences.any?
  end

  class CurrentOffencePresenter < SimpleDelegator
    def full_details
      info = offence
      info << " (CR: #{case_reference})" if case_reference.present?
      info
    end
  end
end
