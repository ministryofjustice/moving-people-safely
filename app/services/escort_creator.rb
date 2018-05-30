class EscortCreator
  def self.call(escort_attrs)
    new(escort_attrs).call
  end

  def initialize(escort_attrs)
    @prison_number = escort_attrs.fetch(:prison_number)
  end

  def call
    if existent_escort
      deep_clone_escort.tap do |clone|
        clone.twig = existent_escort
        clone.needs_review!
      end
    else
      Escort.create(prison_number: prison_number)
    end
  end

  private

  attr_reader :prison_number

  INCLUDE_GRAPH = [
    :detainee,
    { risk: [:must_not_return_details] },
    { healthcare: [:medications] },
    :offences,
    :offences_workflow
  ].freeze

  EXCEPT_GRAPH = [
    :issued_at,
    { risk: %i[reviewer_id reviewed_at] },
    { healthcare: %i[reviewer_id reviewed_at] },
    { offences_workflow: %i[reviewer_id reviewed_at] }
  ].freeze

  def existent_escort
    @existent_escort ||= Escort.uncancelled.find_by(prison_number: prison_number)
  end

  def deep_clone_escort
    existent_escort.deep_clone(
      include: INCLUDE_GRAPH,
      except: EXCEPT_GRAPH
    )
  end
end
