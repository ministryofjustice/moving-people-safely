class CurrentOffencePresenter < SimpleDelegator
  def full_details
    info = offence
    info << " (CR: #{case_reference})" if case_reference.present?
    info
  end
end
