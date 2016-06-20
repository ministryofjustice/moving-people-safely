module Forms
  class MoveInformation < Forms::Base
    REASONS = %w[
      discharge_to_court
      production_to_court
      police_production
      other
    ]
    HAS_DESTINATIONS = %w[ yes no unknown ]

    property :from,             type: StrictString, default: 'HMP Bedford'
    property :to,               type: StrictString
    property :date,             type: TextDate
    property :reason,           type: StrictString
    property :reason_details,   type: StrictString
    property :has_destinations, type: StrictString, default: 'unknown'

    collection :destinations,
      form: Forms::MoveDestination,
      prepopulator: :populate_destinations,
      populator: :handle_incoming_destination_params

    validates :reason,
      inclusion: { in: REASONS },
      allow_blank: true

    validates :reason_details,
      presence: true,
      if: -> { reason == 'other' }

    validate :validate_date

    validates :has_destinations,
      inclusion: { in: HAS_DESTINATIONS },
      allow_blank: true

    def validate_date
      # TODO: extract a common date validator
      errors.add(:date) unless date.is_a? Date
    end

    def reasons
      REASONS
    end

    def has_destinations_values
      HAS_DESTINATIONS
    end

    def add_destination
      destinations << new_destination
    end

    private

    def populate_destinations(*)
      add_destination if destinations.empty?
    end

    # TODO: improve readability of this method
    #
    # rubocop:disable MethodLength
    def handle_incoming_destination_params(
      collection:,
      fragment:,
      represented:,
      **)

      item = destinations.find { |d| d.id == fragment['id'] }

      if fragment['_delete'] == '1' ||
          %w[ yes ].exclude?(represented.has_destinations)
        destinations.delete(item)
        return skip!
      end

      if item
        item
      else
        collection.append(new_destination)
      end
    end

    def new_destination
      model.destinations.build
    end
  end
end
