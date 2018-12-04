# frozen_string_literal: true

class ZendeskTicketCreator
  # Custom ticket field IDs as configured in the MOJ Digital Zendesk account
  SERVICE_FIELD = '23757677'
  PRISON_FIELD = '23984153'
  PRISONER_NUM_FIELD = '114094604912'

  ZendeskNotConfiguredError = Class.new(StandardError)

  def initialize(feedback, user)
    @feedback = feedback
    @user = user
  end

  def call
    raise ZendeskNotConfiguredError unless Rails.configuration.try(:zendesk_client)

    ZendeskAPI::Ticket.create!(Rails.configuration.zendesk_client, ticket_attrs)
  end

  private

  attr_reader :feedback, :user

  def ticket_attrs
    {
      description: feedback.message,
      requester: requester,
      custom_fields: custom_fields
    }
  end

  def requester
    name = user&.full_name || 'Unknown'
    { email: feedback.email, name: name }
  end

  def custom_fields
    [
      { id: PRISON_FIELD, value: user&.authorized_establishments&.first&.name },
      { id: SERVICE_FIELD, value: 'moving_people_safely' },
      { id: PRISONER_NUM_FIELD, value: feedback.prisoner_number }
    ]
  end
end
