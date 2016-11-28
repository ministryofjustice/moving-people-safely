class HomepageController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    search_form.validate(search_params) if search_params.present?
    @moves = Move.for_date(date_picker.date)
    render :show, locals: locals
  end

  def detainees
    redirect_to root_path(search_params)
  end

  def moves
    date_picker.configure(date_picker_params)
    session[:moves_due_on] = date_picker.to_s
    redirect_to root_path(search_params)
  end

  private

  def locals
    {
      search_form: search_form,
      date_picker: date_picker,
      prison_number: params[:prison_number],
      dashboard: DashboardPresenter.new(@moves)
    }
  end

  def date_picker
    @_date_picker ||= DatePickerPresenter.new(session[:moves_due_on])
  end

  def search_form
    @_search_form ||= Forms::Search.new
  end

  def search_params
    params.permit(:prison_number).delete_if { |_key, value| value.blank? }
  end

  def date_picker_params
    { date_shift: params[:commit], date: params[:moves_due_on] }.delete_if { |_key, value| value.blank? }
  end
end
