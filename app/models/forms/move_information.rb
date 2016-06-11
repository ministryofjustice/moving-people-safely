module Forms
  class MoveInformation < Forms::Base
    REASONS = %w[ sentencing part_heard trial plea_and_directions witness ]
    HAS_DESTINATIONS = %w[ yes no unknown ]

    property :from,             type: StrictString, default: 'HMP Bedford'
    property :to,               type: StrictString
    property :date,             type: TextDate
    property :reason,           type: StrictString
    property :has_destinations, type: StrictString, default: 'unknown'

    collection :destinations,
      form: Forms::MoveDestination,
      prepopulator: :populate_destinations,
      populator: :handle_incoming_destination_params

    validates :reason,
      inclusion: { in: REASONS },
      allow_blank: true

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

    # TODO: imrpove readability of this method
    def handle_incoming_destination_params(collection:, fragment:, represented:, **)
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
