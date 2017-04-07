class OffencesPresenter < SimpleDelegator
  def initialize(offences)
    @offences = offences.map { |offence| CurrentOffencePresenter.new(offence) }
    super
  end

  delegate :empty?, :any?, :each, to: :@offences

  alias all_questions_answered? any?

  class CurrentOffencePresenter < SimpleDelegator
    def full_details
      info = offence
      info << " (CR: #{case_reference})" if case_reference.present?
      info
    end
  end
end
