class HomepageCell
  class NoResultsCell < Cell::ViewModel
    inherit_views HomepageCell

    def show
      render :no_results
    end

    private

    alias_method :prison_number, :model

    def create_escort
      button_to('Create new profile',
        escort_path,
        params: { prison_number: prison_number },
        class: 'button')
    end
  end
end
