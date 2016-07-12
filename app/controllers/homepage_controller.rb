class HomepageController < ApplicationController
  def show
    form.validate(prison_number: params[:search]) if params[:search]
    render :show, locals: { form: form, escort: form.escort }
  end

  def search
    redirect_to root_path(search: params[:search]['prison_number'])
  end

  private

  def form
    @_form ||= Forms::Search.new
  end
end
