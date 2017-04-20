module Detainees
  class ImagesController < ApplicationController
    layout :none

    def show
      return head(:not_found) unless detainee&.image.present?
      send_data image, type: 'image/jpeg', disposition: 'inline'
    end

    private

    def escort
      @escort ||= Escort.find(params[:escort_id])
    end

    def detainee
      @detainee ||= escort.detainee
    end

    def image
      Base64.decode64(detainee.image)
    end
  end
end
