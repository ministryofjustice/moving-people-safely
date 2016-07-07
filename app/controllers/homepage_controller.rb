class HomepageController < ApplicationController
  def show
    render :show, locals: { form: form, escort: form.escort }
  end

  def search
    form.validate(params[:search])
    render :show, locals: { form: form, escort: form.escort }
  end

  private

  def form
    @_form ||= Forms::Search.new
  end
end
