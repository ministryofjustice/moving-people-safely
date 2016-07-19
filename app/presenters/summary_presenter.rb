class SummaryPresenter < SimpleDelegator
  def answer_for(attribute)
    value = public_send(attribute)
    case value
    when 'unknown', nil
      "<span class='text-error'>Missing</span>"
    when 'no', false
      'No'
    when true
      '<b>Yes</b>'
    else
      "<b>#{value.humanize}</b>"
    end
  end

  def details_for(question)
    public_send("#{question}_details") if respond_to?("#{question}_details")
  end
end
