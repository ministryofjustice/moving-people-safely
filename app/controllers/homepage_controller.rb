class HomepageController < ApplicationController
  before_action :redirect_to_court_view, if: :court_user?

  def show
    @date_picker = DatePicker.new(session[:escorts_due_on])
    @prison_number = params[:prison_number]
    @escorts = Escort.for_date(@date_picker.date).for_user(current_user)
    @dashboard = DashboardPresenter.new(@escorts)
  end

  def escorts
    date_picker = DatePicker.new(session[:escorts_due_on])
    date_picker.date = params[:escorts_due_on]
    session[:escorts_due_on] = date_picker.to_s
    redirect_to root_path
  end
end
