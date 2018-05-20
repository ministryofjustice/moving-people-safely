class SearchController < ApplicationController
  before_action :authorize_user_to_access_prisoner!, only: :show

  def new
    @form = Forms::Search.new
    render :show
  end

  def show
    @form = Forms::Search.new
    @form.prison_number = prison_number

    if @form.valid?
      @escort = Escort.uncancelled.find_by(prison_number: prison_number)
    else
      flash.now[:error] = t('alerts.search.invalid_identifier', type: 'prison number', identifier: prison_number)
    end
  end

  private

  def search_params
    params.require(:forms_search).permit(:prison_number)
  end

  def prison_number
    search_params[:prison_number].upcase
  end
end
