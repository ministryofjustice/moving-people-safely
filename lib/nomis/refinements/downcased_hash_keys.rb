module Nomis
  module DowncasedHashKeys
    refine Hash do
      def downcase_keys
        {}.tap do |h|
          each { |key, value| h[key.downcase] = transform(value) }
        end
      end

      private def transform(value)
        case value
        when Hash   then value.downcase_keys
        when Array  then value.map { |v| transform(v) }
        else value
        end
      end
    end
  end
end
