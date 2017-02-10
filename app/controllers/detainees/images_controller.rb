module Detainees
  class ImagesController < ApplicationController
    respond_to :jpg
    layout :none

    def show
      return head(:not_found) unless detainee.image.present?
      send_data image, type: 'image/jpeg', disposition: 'inline'
    end

    private

    def detainee
      @detainee ||= Detainee.find(params[:detainee_id])
    end

    def image
      Base64.decode64(detainee.image)
    end
  end
end
