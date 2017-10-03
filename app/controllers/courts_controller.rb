class CourtsController < ApplicationController
  def show
    if session[:court_id]
      @court = Establishment.find(session[:court_id])
      @escorts = Escort.issued.for_today.in_court(@court.name)
    else
      redirect_to select_court_path
    end
  end

  def select
    @form = Forms::CourtSelector.new(Establishment.new)
  end

  def change
    if court_id
      session[:court_id] = court_id
      redirect_to court_path
    else
      redirect_to select_court_path
    end
  end

  private

  def court_id
    return params[:court_selector][:crown_court_id] if params[:court_selector][:crown_court_id].present?
    return params[:court_selector][:magistrates_court_id] if params[:court_selector][:magistrates_court_id].present?
  end
end
