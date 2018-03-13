class EscortPopulator
  def initialize(escort)
    @escort = escort
  end

  def call
    update_detainee
    update_offences
  end

  private

  attr_accessor :escort

  def update_detainee
    result = Detainees::Fetcher.new(escort.prison_number).call
    nomis_detainee_attrs = result.to_h

    detainee.update(nomis_detainee_attrs) if nomis_detainee_attrs.select { |_k, v| v.present? }.many?
  end

  def update_offences
    result = Detainees::OffencesFetcher.new(escort.prison_number).call
    nomis_offences = result.data.map(&:attributes)

    escort.offences.clear.create(nomis_offences) if nomis_offences.any?
  end

  def detainee
    escort.detainee || escort.build_detainee(prison_number: escort.prison_number)
  end
end
