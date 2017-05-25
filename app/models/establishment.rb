class Establishment
  def self.current_for(_prison_number)
    # current will return a dummy record
    # in the future should create an instance of the establishment
    # which contains all the data related with the prisoner's
    # current establishment
    new
  end

  def default_healthcare_contact_number
    # This value is harded-coded here until data
    # is matched against the prisoner's current
    # establishment
    '01234373138'
  end
end
