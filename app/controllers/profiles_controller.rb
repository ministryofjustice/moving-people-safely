class ProfilesController < ApplicationController
  def show
    render locals: { escort: escort }
  end
end
