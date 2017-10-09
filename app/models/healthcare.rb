class Healthcare < ApplicationRecord
  include Questionable
  include Reviewable
  act_as_assessment :healthcare, complex_attributes: %i[medications]

  delegate :editable?, to: :escort

  belongs_to :escort

  after_initialize :set_default_values

  def set_default_values
    if read_attribute(:contact_number).blank? && escort&.move_from_establishment
      write_attribute(:contact_number, escort.move_from_establishment.healthcare_contact_number)
    end
  end
end
