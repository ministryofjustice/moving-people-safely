# frozen_string_literal: true

class EscortCreator
  def self.call(escort_attrs, from_establishment)
    new(escort_attrs, from_establishment).call
  end

  def initialize(escort_attrs, from_establishment)
    @prison_number = escort_attrs[:prison_number]
    @pnc_number = Detainee.standardise_pnc(escort_attrs[:pnc_number]) if escort_attrs[:pnc_number].present?
    @from_establishment = from_establishment
  end

  def call
    if existent_escort
      deep_clone_escort.tap do |clone|
        clone.twig = existent_escort
        clone.move.from_establishment = from_establishment
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
    :move,
    { risk: [:must_not_return_details] },
    { healthcare: [:medications] },
    :offences,
    :offences_workflow
  ].freeze

  EXCEPT_GRAPH = [
    :issued_at,
    :approved_at,
    :approver_id,
    { move: %i[to to_type date not_for_release not_for_release_reason
               not_for_release_reason_details from_establishment_id] },
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
      include: include_graph_for(existent_escort.location),
      except: EXCEPT_GRAPH
    )
  end

  def include_graph_for(location)
    location == 'police' ? INCLUDE_GRAPH - %i[offences offences_workflow] : INCLUDE_GRAPH
  end
end
