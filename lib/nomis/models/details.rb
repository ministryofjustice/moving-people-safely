require 'virtus'
require 'active_support/core_ext/array/conversions'

module Nomis
  class Details
    include Virtus.model

    class Nationality
      include Virtus.model
      attribute :nationality, String
    end

    attribute :birth_date,      Date
    attribute :nationalities,   Array[Nationality]
    attribute :sex,             String
    attribute :cro_number,      String
    attribute :pnc_number,      String
    attribute :working_name,    Boolean
    attribute :agency_location, String

    %i[forenames surname].each do |attr|
      attribute attr, String
      define_method(attr) { super()&.strip.humanize }
    end

    alias_method :current?, :working_name

    def nationalities
      super.presence &&
        super.map(&:nationality).map(&:humanize).to_sentence
    end

    SEX_MAPPING = { 'M' => 'male', 'F' => 'female' }.freeze

    def sex
      SEX_MAPPING[super]
    end
  end
end
