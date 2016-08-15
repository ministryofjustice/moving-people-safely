require 'virtus'

module Nomis
  class Image
    include Virtus.model

    attribute :image, String
    attribute :thumbnail_image, String
  end
end
