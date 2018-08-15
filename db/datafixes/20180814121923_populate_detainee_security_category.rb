class Datafixes::PopulateDetaineeSecurityCategory < Datafix
  def self.up
    cat_a_prison_escorts.each do |escort|
      update_category(escort.detainee)
    end
  end

  def self.down
  end

  def self.cat_a_prison_escorts
    Escort.includes(:detainee)
      .joins(:risk, move: [:from_establishment])
      .where("establishments.type = 'Prison'")
      .where("risks.category_a = 'yes'")
  end

  def self.update_category(detainee)
    if detainee.security_category.blank?
      detainee.update_column(security_category: 'A')
    end
  end
end
