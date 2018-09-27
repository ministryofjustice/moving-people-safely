class Datafixes::AddMedwayPolice < Datafix
  NAME = 'Medway Police Station'.freeze

  def self.up
    PoliceCustody.create(name: NAME)
  end

  def self.down
    PoliceCustody.find_by_name(NAME).delete
  end
end
