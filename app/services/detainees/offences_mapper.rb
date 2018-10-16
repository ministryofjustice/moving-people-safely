# frozen_string_literal: true

module Detainees
  class OffencesMapper
    module BookingsList
      class Offence
        include Virtus.value_object
        attribute :offence, String
        attribute :case_reference, String
      end

      refine Array do
        def active_cases_grouped_by_case_reference
          find { |b| b['booking_active'] }
            .fetch('legal_cases')
            .select { |lc| lc['case_active'] }
            .group_by { |lc| lc['case_info_number'] }
        end

        def value_objects
          map { |attributes| Offence.new(attributes) }
        end
      end

      refine Hash do
        def extract_offences_with_normalised_keys_and_case_reference
          flat_map do |(case_ref, cases)|
            cases
              .flat_map { |c| c['charges'] }
              .select { |c| c['charge_active'] }
              .map do |c|
                offence = c['offence']
                offence['offence'] = offence.delete('desc')
                offence.merge('case_reference' => case_ref)
              end
          end
        end
      end
    end
    private_constant :BookingsList

    using BookingsList

    def initialize(offences)
      @offences = offences
    end

    def call
      @offences['bookings']
        .active_cases_grouped_by_case_reference
        .extract_offences_with_normalised_keys_and_case_reference
        .value_objects
    end
  end
end
