class OffencesPresenter < SimpleDelegator
  def initialize(offences, workflow)
    @offences = offences.map { |offence| CurrentOffencePresenter.new(offence) }
    @workflow = workflow
  end

  delegate :empty?, :any?, :each, :present?, to: :@offences
  delegate :needs_review?, :incomplete?, :unconfirmed?, :confirmed?, to: :@workflow, allow_nil: true

  class CurrentOffencePresenter < SimpleDelegator
    include ActionView::Helpers::SanitizeHelper

    def full_details
      info = sanitize(offence)
      info << " (CR: #{case_reference})" if case_reference.present?
      info
    end
  end
end
