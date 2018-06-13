module Detainees
  class ImagesController < ApplicationController
    layout :none

    def show
      return head(:not_found) unless escort.image.present?
      send_data image, type: 'image/jpeg', disposition: 'inline'
    end

    private

    def escort
      @escort ||= Escort.find(params[:escort_id])
    end

    def image
      Base64.decode64(escort.image)
    end
  end
end
