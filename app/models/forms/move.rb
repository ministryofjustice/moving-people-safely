module Forms
  class Move < Forms::Base
    REASON_WITH_DETAILS = 'other'.freeze
    COMMON_NOT_FOR_RELEASE_REASONS = %w[held_for_immigration other].freeze

    property :to
    property :date, type: TextDate

    optional_field :not_for_release,
      options: TOGGLE_CHOICES,
      allow_blank: false

    property :not_for_release_reason_details, type: StrictString
    validates :not_for_release_reason_details,
      presence: true,
      if: -> { not_for_release == 'yes' && not_for_release_reason == REASON_WITH_DETAILS }

    delegate :persisted?, to: :model

    validates :date, date: { not_in_the_past: true }

    def not_for_release_reason_with_details
      REASON_WITH_DETAILS
    end

    FREE_FORM_DESTINATION_TYPES = %i[hospital other].freeze

    property :to_type, validates: { presence: true }

    ::Establishment::ESTABLISHMENT_TYPES.each do |establishment_type|
      property "to_#{establishment_type}".to_sym,
        virtual: true,
        prepopulator: ->(_options) { send("to_#{establishment_type}=", to) if to_type == establishment_type.to_s }

      validates "to_#{establishment_type}".to_sym,
        presence: true,
        if: -> { to_type == establishment_type.to_s }
    end

    FREE_FORM_DESTINATION_TYPES.each do |destination_type|
      property "to_#{destination_type}".to_sym,
        virtual: true,
        prepopulator: ->(_options) { send("to_#{destination_type}=", to) if to_type == destination_type.to_s }

      validates "to_#{destination_type}".to_sym,
        presence: true,
        if: -> { to_type == destination_type.to_s }
    end

    def save
      self.to = send("to_#{to_type}")
      super
    end
  end
end
