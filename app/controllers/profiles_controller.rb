class ProfilesController < ApplicationController
  def show
    render_cell :profile, escort
  end
end

