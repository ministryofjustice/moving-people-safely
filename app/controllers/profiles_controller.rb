class ProfilesController < ApplicationController
  attr_reader :detainee, :move
  alias active_move move

  def show
    @detainee = Detainee.find(params[:id])
    @move = detainee.active_move
  end
end
