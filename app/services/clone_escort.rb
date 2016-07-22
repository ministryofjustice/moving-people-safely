module CloneEscort
  module_function

  INCLUDE_GRAPH = [
    :move,
    :detainee,
    :risk,
    { healthcare: [:medications] },
    { offences: [:current_offences, :past_offences] }
  ].freeze

  EXCEPT_GRAPH = [
    { move: [:to, :date, :reason, :has_destinations, :reason_details] }
  ].freeze

  REUSE_STATUS = 'needs_review'

  def for_reuse(escort)
    escort.deep_clone(
      include: INCLUDE_GRAPH,
      except: EXCEPT_GRAPH).
      tap do |clone|
        clone.healthcare.workflow_status = REUSE_STATUS
        clone.risk.workflow_status = REUSE_STATUS
        clone.offences.workflow_status = REUSE_STATUS
      end
  end
end
