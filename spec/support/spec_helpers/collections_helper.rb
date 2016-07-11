module CollectionsHelper
  def validate_prepopulated_collection(field_name)
    ValidatePrepopulatedCollection.new(field_name)
  end
end
