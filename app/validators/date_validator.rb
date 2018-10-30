class DateValidator < ActiveModel::EachValidator
  DEFAULT_FORMAT = '%d/%m/%Y'.freeze

  def validate_each(record, attribute, value)
    value = parse_date(value, options[:format]) if value.is_a?(String)
    return unless valid_date(record, attribute, value)

    validate_not_in_past(record, attribute, value)
    validate_not_in_future(record, attribute, value)
  end

  private

  def parse_date(date_str, format)
    format ||= DEFAULT_FORMAT
    Date.strptime(date_str, format)
  rescue
    nil
  end

  def valid_date(record, attribute, value)
    message = options[:message] || :date_not_valid
    unless value.is_a?(Date)
      record.errors.add(attribute, message)
      return false
    end
    true
  end

  def validate_not_in_past(record, attribute, value)
    required = options[:not_in_the_past]
    message = required[:message] if required.is_a?(Hash)
    message ||= :date_is_in_the_past
    record.errors.add(attribute, message) if required.present? && value < Date.current
  end

  def validate_not_in_future(record, attribute, value)
    required = options[:not_in_the_future]
    message = required[:message] if required.is_a?(Hash)
    message ||= :date_is_in_the_future
    record.errors.add(attribute, message) if required.present? && value > Date.current
  end
end
