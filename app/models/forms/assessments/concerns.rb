module Forms
  module Assessments
    module Concerns
      def find_first_match(collection, method_name, *args)
        value = nil
        collection.each_with_object(value) do |item, _match|
          match = item.send(method_name, *args)
          break match if match.present?
        end
      end
    end
  end
end
