class EscortsController < ApplicationController
  def create
    form = Forms::Search.new

    if form.validate(prison_number: params[:prison_number])
      escort = Escort.create_with_children(prison_number: form.prison_number)
      redirect_to detainee_details_path(escort)
    else
      redirect_to root_path
    end
  end

  def clone
    escort = Escort.find(params[:escort_id])
    new_escort = CloneEscort.for_reuse(escort)
    new_escort.save
    redirect_to move_information_path(new_escort)
  end
end
