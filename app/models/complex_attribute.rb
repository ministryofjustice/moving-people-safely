class ComplexAttribute < OpenStruct
  include ActiveModel::Validations

  def persisted?
    id.present?
  end

  def <=>(other)
    to_h <=> other.to_h
  end

  def to_be_deleted?
    _delete == '1'
  end

  def to_h
    super.with_indifferent_access.except(:_delete)
  end
end
