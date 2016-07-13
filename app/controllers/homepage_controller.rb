class HomepageController < ApplicationController
  def show
    search_form.validate(prison_number: params[:search]) if params[:search]
    render :show, locals: locals
  end

  def search
    redirect_to root_path redirect_params(params[:search]['prison_number'])
  end

  def date
    case params[:commit]
    when 'today'
      date_picker.today
    when '<'
      date_picker.back
    when '>'
      date_picker.forward
    when 'Go'
      date_picker.date = params[:date_picker]
    end

    session[:date_in_view] = date_picker.to_s
    redirect_to root_path redirect_params(params[:search])
  end

  private

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
      result: search_form.escort,
      date_picker: date_picker,
      prison_number: params[:search]
    }
  end

  def date_picker
    @_date_picker ||= DatePicker.new(session[:date_in_view])
  end

  def search_form
    @_search_form ||= Forms::Search.new
  end
end
