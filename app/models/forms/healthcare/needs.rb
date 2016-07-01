module Forms
  module Healthcare
    class Needs < Forms::Base
      optional_details_field :dependencies
      optional_field :medication

      collection :medications,
        form: Forms::Healthcare::Medication,
        prepopulator: :populate_medications,
        populator: :handle_nested_params

      def add_medication
        medications << new_medication
      end

      private

      def populate_medications(*)
        add_medication if medications.empty?
      end

      def handle_nested_params(collection:, fragment:, **)
        item = medications.find { |d| (d.id == fragment['id']) }

        marked_to_be_deleted = fragment['_delete'] == '1'
        all_to_be_deleted = %w[ yes ].exclude?(medication)

        if marked_to_be_deleted || all_to_be_deleted
          medications.delete(item)
          return skip!
        end

        if item
          item
        else
          collection.append(new_medication)
        end
      end

      def new_medication
        model.medications.build
      end
    end
  end
end
