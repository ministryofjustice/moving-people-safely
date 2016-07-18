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
    moves_for_date = Move.for_date(date_picker.date)

    {
      search_form: search_form,
      result: search_form.escort,
      date_picker: date_picker,
      prison_number: params[:search],
      moves: moves_for_date,
      count_of_incomplete_risks: moves_for_date.with_incomplete_risks.count,
      count_of_incomplete_healthcare: moves_for_date.with_incomplete_healthcare.count,
      count_of_incomplete_offences: moves_for_date.with_incomplete_offences.count
    }
  end

  def date_picker
    @_date_picker ||= DatePicker.new(session[:date_in_view])
  end

  def search_form
    @_search_form ||= Forms::Search.new
  end
end
