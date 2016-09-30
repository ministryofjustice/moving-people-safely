class SearchForm
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  PRISON_NUMBER_REGEX = /\A[a-z]\d{4}[a-z]{2}\z/i

  def prison_number
    @query
  end

  def prison_number=(query)
    if validate_prison_number(query)
      @query = query
    else
      @query = nil
    end
  end

  def validate(prison_number:)
    @query = prison_number
  end

  def valid?
    validate_prison_number(@query)
  end

  def detainee
    @_detainee ||= Detainee.find_by(prison_number: @query) if valid?
  end

  def errors
    _errors ||= ActiveModel::Errors.new(self)
    _errors.add(:prison_number, :blank, message: "can't be blank") if @query.nil?
    _errors.add(:prison_number, :format, message: 'is incorrect') unless valid?
    _errors
  end

  # le sigh
  def id; nil; end
  def persisted?; false; end
  def to_key; nil; end

  def name
    'search'
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  private

  def validate_prison_number(prison_number)
    prison_number =~ PRISON_NUMBER_REGEX
  end
end
