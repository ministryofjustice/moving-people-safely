class HomepageController < ApplicationController
  before_action :redirect_to_court_view, if: :court_user?
  before_action :redirect_to_select_police_station, only: :show, if: :police_user_without_station?

  def show
    @date_picker = DatePicker.new(session[:escorts_due_on])
    escorts = Escort.for_date(@date_picker.date).for_establishment(current_user.establishment(session))
    @dashboard = DashboardPresenter.new(escorts)
  end

  def escorts
    date_picker = DatePicker.new(session[:escorts_due_on])
    date_picker.date = params[:escorts_due_on]
    session[:escorts_due_on] = date_picker.to_s
    redirect_to root_path
  end

  def select_police_station
    @form = Forms::PoliceStationSelector.new(PoliceCustody.new)
  end

  def set_police_station
    if params[:police_station_selector][:police_custody_id]
      session[:police_station_id] = params[:police_station_selector][:police_custody_id]
      redirect_to root_path
    else
      redirect_to select_police_station_path
    end
  end

  private

  def court_user?
    current_user.court?
  end

  def redirect_to_court_view
    redirect_to court_path
  end

  def police_user_without_station?
    current_user.police? && session[:police_station_id].blank?
  end

  def redirect_to_select_police_station
    redirect_to select_police_station_path
  end
end
