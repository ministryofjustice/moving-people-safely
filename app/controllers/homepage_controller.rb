class HomepageController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    search_form.validate(prison_number: params[:search]) if params[:search]
    render :show, locals: locals
  end

  def search
    redirect_to root_path redirect_params(params[:search]['prison_number'])
  end

  def date
    configure_date_picker
    session[:date_in_view] = date_picker.to_s
    redirect_to root_path redirect_params(params[:search])
  end

  private

  def configure_date_picker
    case params[:commit]
    when 'today'
      AnalyticsEvent.publish('date_change', new_date: :today)
      date_picker.today
    when '<'
      AnalyticsEvent.publish('date_change', new_date: :back)
      date_picker.back
    when '>'
      AnalyticsEvent.publish('date_change', new_date: :forward)
      date_picker.forward
    when 'Go'
      AnalyticsEvent.publish('date_change', new_date: params[:date_picker])
      date_picker.date = params[:date_picker]
    end
  end

  def redirect_params(search_query)
    if search_query.present?
      { search: search_query }
    else
      {}
    end
  end

  def locals
    {
      search_form: search_form,
      date_picker: date_picker,
      prison_number: params[:search],
      dashboard: DashboardPresenter.new(date_picker.date)
    }
  end

  def date_picker
    @_date_picker ||= DatePicker.new(session[:date_in_view])
  end

  def search_form
    @_search_form ||= SearchForm.new
  end
end
