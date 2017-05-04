class EscortCreator
  def self.call(escort_attrs)
    new(escort_attrs).call
  end

  def initialize(escort_attrs)
    @prison_number = escort_attrs.fetch(:prison_number)
  end

  def call
    if existent_escort
      deep_clone_escort.tap(&:needs_review!)
    else
      Escort.create(prison_number: prison_number)
    end
  end

  private

  attr_reader :prison_number

  INCLUDE_GRAPH = [
    { detainee: [:offences] },
    { move: [:destinations] },
    :risk,
    { healthcare: [:medications] }
  ].freeze

  EXCEPT_GRAPH = [{ move: [:date] }].freeze

  def existent_escort
    @existent_escort ||= Escort.find_by(prison_number: prison_number)
  end

  def deep_clone_escort
    existent_escort.deep_clone(
      include: INCLUDE_GRAPH,
      except: EXCEPT_GRAPH
    )
  end
end
