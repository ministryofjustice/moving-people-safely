module Considerations
  module CommonConcerns
    TERNARY_ON_VALUE = 'yes'
    TERNARY_OPTIONS = %w[ yes no unknown ]
    REASONABLE_STRING_LENGTH = 200

    TERNARY_TEST = proc do |top, checkbox, details|
      (top.eql?(TERNARY_ON_VALUE) & checkbox.true?) > details.filled?
    end

    OPTIONAL_DETAILS_TEST = proc do |option, details|
      option.eql?(TERNARY_ON_VALUE) > details.filled?
    end

    BOOLEAN_OPTIONAL_DETAILS_TEST = proc do |option, details|
      option.eql?(true) > details.filled?
    end

    OPTIONAL_MULTIPLE_TEST = proc do |option, multiple|
      option.eql?(TERNARY_ON_VALUE) > multiple.value(min_size?: 1)
    end
  end
end
