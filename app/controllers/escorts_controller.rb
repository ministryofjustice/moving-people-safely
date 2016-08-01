class EscortsController < ApplicationController
  before_action :redirect_if_no_clone_permission, only: [:clone]

  def create
    form = Forms::Search.new

    if form.validate(prison_number: params[:prison_number])
      escort = Escort.create_with_children(prison_number: form.prison_number)
      redirect_to detainee_details_path(escort.detainee)
    else
      redirect_to root_path
    end
  end

  def clone
    new_escort = CloneEscort.for_reuse(escort)
    new_escort.save
    redirect_to move_information_path(new_escort)
  end

  private

  def escort
    @_escort ||= Escort.find(params[:escort_id])
  end

  def redirect_if_no_clone_permission
    unless AccessPolicy.clone_escort?(escort: escort)
      redirect_back(fallback_location: root_path)
    end
  end
end
