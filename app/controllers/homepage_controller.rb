class HomepageController < ApplicationController
  def show
    form.validate(prison_number: params[:search]) if params[:search]
    render :show, locals: locals
  end

  def search
    redirect_to root_path(search: params[:search]['prison_number'])
  end

  def date_picker
    date_picker_form.validate(params[:date_picker])

    case params[:commit]
    when 'today'
      date = Date.today
    when '<'
      date = date_to_show - 1.day
    when '>'
      date = date_to_show + 1.day
    when 'Go'
      date = date_picker_form.date
    end

    session[:date_in_view] = date.to_s
    redirect_to root_path(search: params[:search])
  end

  private

  def date_to_show
    date = session[:date_in_view] || Date.today.strftime('%d/%m/%Y')
    Date.strptime(date, '%d/%m/%Y')
  end

  def locals
    {
      form: form,
      result: form.escort,
      date_picker: date_picker_form
    }
  end

  def date_picker_form
    @_date_picker_form ||= Forms::DatePicker.new
  end

  def form
    @_form ||= Forms::Search.new
  end
end
