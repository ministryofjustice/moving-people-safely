class HomepageController < ApplicationController
  def show
    render_cell :homepage, Forms::Search.new
  end

  def search
    form = Forms::Search.new
    form.assign_attributes(search_attributes)
    render_cell :homepage, form
  end

  private

  def search_attributes
    params[:search]
  end
end
