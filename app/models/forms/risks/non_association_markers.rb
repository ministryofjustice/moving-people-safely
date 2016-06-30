module Forms
  module Risks
    class NonAssociationMarkers < Forms::Base
      optional_field :non_association

      collection :non_association_markers,
        form: Forms::Risks::NonAssociationMarker,
        prepopulator: :populate_non_association_markers,
        populator: :handle_incoming_non_association_marker_params

      def add_non_association_marker
        non_association_markers << new_non_association_marker
      end

      private

      def populate_non_association_markers(*)
        add_non_association_marker if non_association_markers.empty?
      end

      # TODO: improve readability of this method
      #
      # rubocop:disable MethodLength
      def handle_incoming_non_association_marker_params(
        collection:,
        fragment:,
        represented:,
        **)

        item = non_association_markers.find { |d| d.id == fragment['id'] }

        if fragment['_delete'] == '1' ||
            %w[ yes ].exclude?(represented.non_association)
          non_association_markers.delete(item)
          return skip!
        end

        if item
          item
        else
          collection.append(new_non_association_marker)
        end
      end
      # rubocop:enable MethodLength

      def new_non_association_marker
        model.non_association_markers.build
      end
    end
  end
end
