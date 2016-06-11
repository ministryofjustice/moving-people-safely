class EscortsController < ApplicationController
  def create
    form = Forms::Search.new

    if form.validate(prison_number: params[:prison_number])
      escort = Escort.new
      escort.build_detainee(prison_number: form.prison_number)
      escort.save!

      redirect_to detainee_details_path(escort)
    else
      redirect_to root_path
    end
  end
end
