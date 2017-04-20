class Detainee < ApplicationRecord
  belongs_to :escort
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :offences, dependent: :destroy

  def initialize(*)
    super
    build_healthcare
    build_risk
    build_offences
  end

  def age
    AgeCalculator.age(date_of_birth)
  end

  def each_alias
    return [] unless aliases.present?
    aliases.split(',').each { |a| yield a }
  end
end
