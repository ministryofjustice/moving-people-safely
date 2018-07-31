class Datafixes::RenameSalfords < Datafix
  OLD_NAME = 'Salfords Police Custody Suite / Reigate Police Station (Surrey Police Station)'.freeze
  NEW_NAME = 'Salfords Police Custody Suite'.freeze

  def self.up
    PoliceCustody.find_by_name(OLD_NAME).update_column(:name, NEW_NAME)
  end

  def self.down
    PoliceCustody.find_by_name(NEW_NAME).update_column(:name, OLD_NAME)
  end
end
