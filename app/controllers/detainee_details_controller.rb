class DetaineeDetailsController < ApplicationController
  def show
    render html: "Prison number: #{escort.detainee.prison_number}", layout: true
  end

  private

  def escort
    @escort ||= Escort.find(params[:id])
  end
end
