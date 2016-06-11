class DetaineeDetailsCell < Cell::ViewModel
  property :form
  property :escort

  def form_url
    detainee_details_url(escort)
  end
end
