class HomepageController < ApplicationController
  def show
    render :show, locals: { form: form }
  end

  def search
    form.validate(params[:search])
    render :show, locals: { form: form }
  end

  private

  def form
    @_form ||= Forms::Search.new
  end
end
