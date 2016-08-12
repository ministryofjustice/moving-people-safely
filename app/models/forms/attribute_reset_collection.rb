module Forms
  class AttributeResetCollection
    ResetData = Struct.new(:attributes_to_reset, :master_attribute, :enabled_value)

    def initialize
      @collection = []
    end

    def add(*args)
      @collection << ResetData.new(*args)
    end

    def perform(form)
      @collection.each do |reset_obj|
        next if form.public_send(reset_obj.master_attribute) == reset_obj.enabled_value

        reset_obj.attributes_to_reset.each do |attribute|
          form.public_send("#{attribute}=", nil)
        end
      end
    end
  end
end
