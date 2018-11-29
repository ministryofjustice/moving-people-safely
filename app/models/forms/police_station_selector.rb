module Forms
  class PoliceStationSelector
    include ActiveModel::Model

    attr_accessor :police_custody_id
    validates :police_custody_id, presence: true

    class << self
      def name
        super.demodulize.underscore
      end
    end
  end
end
