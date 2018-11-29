module Forms
  class Move < Forms::Base
    FREE_FORM_DESTINATION_TYPES = %i[civil_court hospital other].freeze
    REASON_WITH_DETAILS = 'other'.freeze
    COMMON_NOT_FOR_RELEASE_REASONS = %w[held_for_immigration other].freeze
    PRISON_NOT_FOR_RELEASE_REASONS = %w[serving_sentence further_charges licence_revoke].freeze
    POLICE_NOT_FOR_RELEASE_REASONS = %w[prison_production recall_to_prison].freeze

    property :to

    property :date, type: TextDate
    validates :date, date: { not_in_the_past: true }

    options_field :not_for_release
    options_field :not_for_release_reason, options: :not_for_release_reasons, if: -> { not_for_release == 'yes' }

    reset attributes: %i[not_for_release_reason not_for_release_reason_details],
          if_falsey: :not_for_release

    reset attributes: [:not_for_release_reason_details],
          if_falsey: :not_for_release_reason,
          enabled_value: REASON_WITH_DETAILS

    property :not_for_release_reason_details, type: StrictString
    validates :not_for_release_reason_details,
      presence: true,
      if: -> { not_for_release == 'yes' && not_for_release_reason == REASON_WITH_DETAILS }

    options_field_with_details :require_special_vehicle, allow_blank: true
    options_field_with_details :other_transport_requirements, allow_blank: true

    def not_for_release_reasons
      if model.from_police?
        POLICE_NOT_FOR_RELEASE_REASONS + COMMON_NOT_FOR_RELEASE_REASONS
      else
        PRISON_NOT_FOR_RELEASE_REASONS + COMMON_NOT_FOR_RELEASE_REASONS
      end
    end

    def not_for_release_reason_with_details
      REASON_WITH_DETAILS
    end

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

    options_field :travelling_with_child, if: :female_from_prison?

    property :child_full_name, type: StrictString
    validates :child_full_name,
      presence: true,
      if: -> { travelling_with_child == 'yes' && female_from_prison? }

    property :child_date_of_birth, type: TextDate
    validates :child_date_of_birth,
      presence: true,
      date: { not_in_the_future: true },
      if: -> { travelling_with_child == 'yes' && female_from_prison? }

    def save
      self.to = send("to_#{to_type}")
      super
    end

    def sorted_destination_options
      sorted_list = (FREE_FORM_DESTINATION_TYPES + Establishment::ESTABLISHMENT_TYPES - [:other]).sort
      sorted_list + [:other]
    end
  end
end
