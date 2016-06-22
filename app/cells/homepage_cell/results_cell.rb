class HomepageCell
  class ResultsCell < Cell::ViewModel
    inherit_views HomepageCell

    property :detainee_prison_number
    property :detainee_surname
    property :detainee_forenames
    property :move_to

    def show
      render :results
    end

    private

    def detainee_date_of_birth
      model.detainee_date_of_birth&.to_s(:humanized)
    end

    def move_date
      model.move_date&.to_s(:humanized)
    end

    def review_profile
      link_to('Review profile', profile_path(model), class: 'button')
    end
  end
end
