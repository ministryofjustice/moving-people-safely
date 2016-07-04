class ProfileCell < Cell::ViewModel
  private

  alias_method :escort, :model

  def home_link
    link_to 'Homepage', root_path
  end

  def detainee_details_link
    link_to 'Detainee details', detainee_details_path(escort)
  end

  def move_information_link
    link_to 'Move information', move_information_path(escort)
  end

  def healthcare_link
    link_to 'Healthcare', healthcare_path(escort, :physical)
  end

  def risks_link
    link_to 'Risks', risks_path(escort, :risks_to_self)
  end

  def prison_number
    escort.detainee.prison_number
  end
end
