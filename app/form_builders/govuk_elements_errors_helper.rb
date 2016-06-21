module GovukElementsErrorsHelper
  def self.link_to_error(object_prefixes, attribute)
    # Remove possible nested part of attribute.
    # Without this patch the link to a nested field with an error would be:
    # #error_model_attribute.nested_attribute
    # instead of simply:
    # #error_model_attribute
    attribute = attribute.to_s.sub(/\..*/, '')
    ['#error', *object_prefixes, attribute].join('_')
  end
end
