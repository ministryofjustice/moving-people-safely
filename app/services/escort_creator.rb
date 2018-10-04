class EscortCreator
  def self.call(escort_attrs, from_establishment)
    new(escort_attrs, from_establishment).call
  end

  def initialize(escort_attrs, from_establishment)
    @prison_number = escort_attrs[:prison_number]
    @pnc_number = escort_attrs[:pnc_number]
    @from_establishment = from_establishment
  end

  def call
    if existent_escort
      deep_clone_escort.tap do |clone|
        build_move_with_special_vehicle_details(clone)
        clone.twig = existent_escort
        clone.needs_review!
      end
    else
      Escort.create(prison_number: prison_number, pnc_number: pnc_number).tap do |escort|
        escort.create_move(from_establishment: from_establishment)
      end
    end
  end

  private

  attr_reader :prison_number, :pnc_number, :from_establishment

  INCLUDE_GRAPH = [
    :detainee,
    { risk: [:must_not_return_details] },
    { healthcare: [:medications] },
    :offences,
    :offences_workflow
  ].freeze

  EXCEPT_GRAPH = [
    :issued_at,
    :approved_at,
    :approver_id,
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

  def build_move_with_special_vehicle_details(escort)
    escort.build_move(
      from_establishment: from_establishment,
      require_special_vehicle: existent_escort.move.require_special_vehicle,
      require_special_vehicle_details: existent_escort.move.require_special_vehicle_details,
      other_transport_requirements: existent_escort.move.other_transport_requirements,
      other_transport_requirements_details: existent_escort.move.other_transport_requirements_details
    )
  end
end
