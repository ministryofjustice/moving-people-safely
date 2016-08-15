require 'virtus'

module Nomis
  class Nationality
    include Virtus.model
    attribute :nationality, String
  end
end
