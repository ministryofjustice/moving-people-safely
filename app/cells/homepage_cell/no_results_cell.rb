class HomepageCell
  class NoResultsCell < Cell::ViewModel
    inherit_views HomepageCell

    def show
      render :no_results
    end

    private

    alias_method :prison_number, :model

    def create_escort
      # TODO: this should hit the escort create action
      button_to('Create new profile', class: 'button')
    end
  end
end


