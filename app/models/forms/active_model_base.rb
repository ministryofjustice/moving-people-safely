# frozen_string_literal: true

module Forms
  class ActiveModelBase
    include ActiveModel::Model

    class << self
      def name
        super.demodulize.underscore
      end
    end
  end
end
