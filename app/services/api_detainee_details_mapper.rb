require 'countries'

class ApiDetaineeDetailsMapper
  attr_reader :prison_number, :details

  def initialize(prison_number, details)
    @prison_number = prison_number
    @details = details.with_indifferent_access
  end

  def call
    {
      prison_number: prison_number,
      forenames: mapped_forenames,
      surname: details[:surname],
      date_of_birth: mapped_dob,
      gender: mapped_gender,
      nationalities: mapped_nationality,
      pnc_number: details[:pnc_number],
      cro_number: details[:cro_number]
    }.with_indifferent_access
  end

  private

  def dob
    details[:date_of_birth]
  end

  def mapped_dob
    return unless dob.present?
    Date.parse(dob).strftime('%d/%m/%Y')
  rescue
    nil
  end

  def given_name
    details[:given_name]
  end

  def middle_names
    details[:middle_names]
  end

  def names
    [given_name, middle_names]
  end

  def mapped_forenames
    present_names = names.select(&:present?)
    return if present_names.empty?
    present_names.join(' ')
  end

  def gender
    details[:gender]
  end

  def mapped_gender
    { 'm' => 'male', 'f' => 'female' }[gender.downcase] if gender.present?
  end

  def nationality_code
    details[:nationality_code]
  end

  def mapped_nationality
    return unless nationality_code.present?
    country = ISO3166::Country.new(nationality_code)
    (country && country.nationality) || nationality_code
  end
end
