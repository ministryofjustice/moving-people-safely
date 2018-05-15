class HomepageController < ApplicationController
  before_action :redirect_to_court_view, if: :court_user?

  def show
    @escorts = Escort.for_date(date_picker.date).for_user(current_user)
    render :show, locals: locals
  end

  def escorts
    date_picker.date = params[:escorts_due_on]
    session[:escorts_due_on] = date_picker.to_s
    redirect_to root_path
  end

  private

  def locals
    {
      date_picker: date_picker,
      prison_number: params[:prison_number],
      dashboard: DashboardPresenter.new(@escorts)
    }
  end

  def date_picker
    @_date_picker ||= DatePicker.new(session[:escorts_due_on])
  end
end
