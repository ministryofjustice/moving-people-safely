class Datafixes::RenameWestCumbria < Datafix
  OLD_NAME = "West Cumbria Magistrates' Court".freeze
  NEW_NAME = "West Cumbria (Workington) Magistrates' Court".freeze

  def self.up
    MagistratesCourt.find_by_name(OLD_NAME).update_column(:name, NEW_NAME)
  end

  def self.down
    MagistratesCourt.find_by_name(NEW_NAME).update_column(:name, OLD_NAME)
  end
end
