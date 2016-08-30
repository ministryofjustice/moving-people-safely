module Forms
  class AttributeResetCollection
    # ([Symbol::Attribute], Symbol::Attribute, String) => Struct::ResetData
    ResetData = Struct.new(:attributes_to_reset, :master_attribute, :enabled_value)

    def initialize
      @collection = []
    end

    attr_reader :collection

    def add(*args)
      collection << ResetData.new(*args)
    end

    def any?
      collection.any?
    end

    def reset_all(form, defaults)
      collection.each do |reset_obj|
        next if form.public_send(reset_obj.master_attribute) == reset_obj.enabled_value

        reset_obj.attributes_to_reset.each do |attribute|
          form.public_send("#{attribute}=", defaults[attribute])
        end
      end
    end
  end
end
