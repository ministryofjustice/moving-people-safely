class MoveInformationCell < Cell::ViewModel
  property :form
  property :escort

  def form_url
    move_information_url(escort)
  end
end
