require 'countries'

class DetaineeDetailsFetcher
  def initialize(prison_number)
    @prison_number = prison_number
    @offenders_search_path = '/offenders/search'
  end

  def call
    return {} unless prison_number.present?
    Rails.logger.info "[OffendersApi] Requesting to #{offenders_search_path} for offender with noms id #{prison_number}"
    response = Rails.offenders_api_client.get(offenders_search_path, params: { noms_id: prison_number })
    return {} unless response.status == 200
    detainee_attrs_from(response)
  rescue => e
    Rails.logger.error "[OffendersApi] #{e.inspect}"
    {}
  end

  private

  attr_reader :prison_number, :offenders_search_path

  def detainee_attrs_from(response)
    hash = JSON.parse(response.body).first.with_indifferent_access
    {
      prison_number: prison_number,
      forenames: map_forenames(hash[:given_name], hash[:middle_names]),
      surname: hash[:surname],
      date_of_birth: map_dob(hash[:date_of_birth]),
      gender: map_gender(hash[:gender]),
      nationalities: map_nationality(hash[:nationality_code]),
      pnc_number: hash[:pnc_number],
      cro_number: hash[:cro_number]
    }.with_indifferent_access
  end

  def map_dob(dob)
    return unless dob.present?
    Date.parse(dob).strftime('%d/%m/%Y')
  rescue
    nil
  end

  def map_forenames(*names)
    present_names = names.select(&:present?)
    return if present_names.empty?
    present_names.join(' ')
  end

  def map_gender(gender)
    { 'm' => 'male', 'f' => 'female' }[gender.downcase] if gender.present?
  end

  def map_nationality(nationality_code)
    return unless nationality_code.present?
    country = ISO3166::Country.new(nationality_code)
    (country && country.nationality) || nationality_code
  end
end
