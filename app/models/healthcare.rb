class Healthcare < ApplicationRecord
  include Questionable
  include Reviewable
  act_as_assessment :healthcare, complex_attributes: %i[medications]

  after_initialize :set_default_values

  def set_default_values
    unless read_attribute(:contact_number).present?
      write_attribute(:contact_number, default_contact_number)
    end
  end

  belongs_to :escort

  delegate :current_establishment, to: :escort, allow_nil: true

  def default_contact_number
    current_establishment&.default_healthcare_contact_number
  end
end
