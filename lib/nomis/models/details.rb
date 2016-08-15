require 'virtus'
require 'nomis/models/nationality'

module Nomis
  class Details
    include Virtus.model

    attribute :prison_number,   String
    attribute :forenames,       String
    attribute :surname,         String
    attribute :birth_date,      Date
    attribute :nationalities,   Array[Nationality]
    attribute :sex,             String
    attribute :cro_number,      String
    attribute :pnc_number,      String
    attribute :working_name,    Boolean
    attribute :agency_location, String

    def current?
      working_name
    end

    def nationalities
      super.presence && super.map(&:nationality).join(', ')
    end

    SEX_MAPPING = { 'M' => 'male', 'F' => 'female' }.freeze

    def sex
      SEX_MAPPING[super]
    end
  end
end
