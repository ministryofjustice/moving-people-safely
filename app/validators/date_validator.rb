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
    message = options[:message] || 'is not a valid date'
    unless value.is_a?(Date)
      record.errors[attribute] << message
      return false
    end
    true
  end

  def validate_not_in_past(record, attribute, value)
    required = options[:not_in_the_past]
    message = required[:message] if required.is_a?(Hash)
    message ||= 'is in the past'
    record.errors[attribute] << message if required.present? && value < Time.current.to_date
  end

  def validate_not_in_future(record, attribute, value)
    required = options[:not_in_the_future]
    message = required[:message] if required.is_a?(Hash)
    message ||= 'is in the future'
    record.errors[attribute] << message if required.present? && value > Time.current.to_date
  end
end
