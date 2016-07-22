module FormsHelper
  def validate_prepopulated_collection(field_name)
    ValidatePrepopulatedCollection.new(field_name)
  end

  def validate_optional_field(field_name)
    ValidateOptionalField.new(field_name)
  end

  def validate_optional_details_field(field_name)
    ValidateOptionalDetailsField.new(field_name)
  end

  def validate_strict_string(field_name)
    ValidateStrictString.new(field_name)
  end
end
