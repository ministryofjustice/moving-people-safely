# frozen_string_literal: true

module Forms
  class Search < ActiveModelBase
    attr_accessor :prison_number, :pnc_number

    validates :prison_number,
      format: { with: Forms::Detainee::PRISON_NUMBER_REGEX },
      if: :prison_number

    validates :pnc_number,
      format: { with: Forms::Detainee::POLICE_NUMBER_REGEX },
      if: :pnc_number

    def initialize(search = {})
      @prison_number = search[:prison_number]&.upcase
      @pnc_number = search[:pnc_number]&.upcase
    end

    def identifier
      prison_number || pnc_number
    end

    def identifier_type
      return 'PNC number' if pnc_number

      'prison number'
    end
  end
end
