class EscortCreator
  def self.call(escort_attrs)
    new(escort_attrs).call
  end

  def initialize(escort_attrs)
    @prison_number = escort_attrs[:prison_number]
    @pnc_number = escort_attrs[:pnc_number]
  end

  def call
    if existent_escort
      deep_clone_escort.tap do |clone|
        clone.twig = existent_escort
        clone.needs_review!
      end
    else
      Escort.create(prison_number: prison_number, pnc_number: pnc_number)
    end
  end

  private

  attr_reader :prison_number, :pnc_number

  INCLUDE_GRAPH = [
    { risk: [:must_not_return_details] },
    { healthcare: [:medications] },
    :offences,
    :offences_workflow
  ].freeze

  EXCEPT_GRAPH = [
    :issued_at,
    :date,
    :to,
    :to_type,
    :from_establishment_id,
    :not_for_release,
    :not_for_release_reason,
    :not_for_release_reason_details,
    { risk: %i[reviewer_id reviewed_at] },
    { healthcare: %i[reviewer_id reviewed_at] },
    { offences_workflow: %i[reviewer_id reviewed_at] }
  ].freeze

  def existent_escort
    return @existent_escort if @existent_escort
    @existent_escort = Escort.uncancelled
    @existent_escort = @existent_escort.from_prison.find_by(prison_number: prison_number) if prison_number.present?
    @existent_escort = @existent_escort.from_police.find_by(pnc_number: pnc_number) if pnc_number.present?
    @existent_escort
  end

  def deep_clone_escort
    existent_escort.deep_clone(
      include: INCLUDE_GRAPH,
      except: EXCEPT_GRAPH
    )
  end
end
