class HomepageController < ApplicationController
  def show
    render_cell :homepage
  end

  private

  def render_cell(*cell_attrs)
    render html: cell(*cell_attrs), layout: true
  end
end
