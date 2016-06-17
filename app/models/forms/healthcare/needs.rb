module Forms
  module Healthcare
    class Needs < Forms::Base
      optional_details_field :dependencies
      optional_field :medication

      collection :medications,
        form: Forms::Healthcare::Medication,
        prepopulator: :populate_medications,
        populator: :handle_incoming_medication_params

      def add_medication
        medications << new_medication
      end

      def carrier_values
        Forms::Healthcare::Medication::CARRIER_VALUES
      end

      private

      def populate_medications(*)
        add_medication if medications.empty?
      end

      # TODO: improve readability of this method
      #
      # rubocop:disable MethodLength
      def handle_incoming_medication_params(
        collection:,
        fragment:,
        represented:,
        **)

        item = medications.find { |d| d.id == fragment['id'] }

        if fragment['_delete'] == '1' ||
            %w[ yes ].exclude?(represented.medication)
          medications.delete(item)
          return skip!
        end

        if item
          item
        else
          collection.append(new_medication)
        end
      end
      # rubocop:enable MethodLength

      def new_medication
        model.medications.build
      end
    end
  end
end
