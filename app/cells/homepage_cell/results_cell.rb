class HomepageCell
  class ResultsCell < Cell::ViewModel
    inherit_views HomepageCell

    property :detainee_prison_number
    property :detainee_surname
    property :detainee_forenames
    property :detainee_date_of_birth
    property :move_date
    property :move_to

    def show
      render :results
    end

    private

    def review_profile
      link_to('Review profile', profile_path(model), class: 'button')
    end
  end
end
