class EscortCreator
  attr_reader :nomis_errors

  def initialize(escort_attrs)
    @prison_number = escort_attrs.fetch(:prison_number)
    @nomis_errors = []
  end

  def call
    clone_or_create_escort.tap do |escort|
      refresh_offences(escort)
    end
  end

  private

  attr_reader :prison_number

  INCLUDE_GRAPH = [
    { detainee: [:offences] },
    :risk,
    :healthcare,
    :offences_workflow
  ].freeze

  EXCEPT_GRAPH = [
    :issued_at,
    { risk: %i[reviewer_id reviewed_at] },
    { healthcare: %i[reviewer_id reviewed_at] }
  ].freeze

  def clone_or_create_escort
    if existent_escort
      deep_clone_escort.tap do |clone|
        clone.twig = existent_escort
        clone.needs_review!
      end
    else
      create_escort_with_detainee
    end
  end

  def create_escort_with_detainee
    Escort.create(prison_number: prison_number).tap do |escort|
      escort.create_detainee(
        fetch_detainee_details.merge(prison_number: prison_number)
      )
    end
  end

  def existent_escort
    @existent_escort ||=
      Escort.uncancelled.find_by(prison_number: prison_number)
  end

  def deep_clone_escort
    existent_escort.deep_clone(
      include: INCLUDE_GRAPH,
      except: EXCEPT_GRAPH
    )
  end

  def refresh_offences(escort)
    if nomis_offences.any?
      escort.offences.clear if escort.offences.present?
      escort.offences.build(nomis_offences)
      escort.detainee.save
    end
  end

  def nomis_offences
    @nomis_offences ||= fetch_offences
  end

  def fetch_offences
    result = Detainees::OffencesFetcher.new(prison_number).call
    @nomis_errors << "alerts.offences.#{result.error}" if result.error.present?
    result.data.map(&:attributes)
  end

  def fetch_detainee_details
    result = Detainees::Fetcher.new(prison_number).call

    if result.errors.present?
      @nomis_errors += result.errors.map { |err| "alerts.detainee.#{err}" }
    end

    result.to_h.with_indifferent_access
  end
end
