class HomepageController < ApplicationController
  before_action :validate_search, only: :show
  before_action :authorize_user!, only: :show, if: :valid_search?

  def show
    @escorts = Escort.for_date(date_picker.date)
    render :show, locals: locals
  end

  def detainees
    redirect_to root_path(search_params)
  end

  def escorts
    date_picker.date = params[:escorts_due_on]
    session[:escorts_due_on] = date_picker.to_s
    redirect_to root_path(search_params)
  end

  private

  def validate_search
    search_form.validate(search_params) if search_params.present?
  end

  def valid_search?
    search_params.present? && search_form.valid?
  end

  def prison_number
    search_form.prison_number
  end

  def locals
    {
      search_form: search_form,
      date_picker: date_picker,
      prison_number: params[:prison_number],
      dashboard: DashboardPresenter.new(@escorts)
    }
  end

  def date_picker
    @_date_picker ||= DatePicker.new(session[:escorts_due_on])
  end

  def search_form
    @_search_form ||= Forms::Search.new
  end

  def search_params
    params.permit(:prison_number).delete_if { |_key, value| value.blank? }
  end
end
