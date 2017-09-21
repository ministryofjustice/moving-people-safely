require 'rails_helper'

RSpec.describe ZendeskTicketCreator do
  let(:email) { 'email@example.com' }
  let(:prisoner_number) { 'A1234AB' }
  let(:message) { 'Problem with the PER.' }
  let(:feedback) { Forms::Feedback.new(email: email, prisoner_number: prisoner_number, message: message) }
  let(:user) { nil }

  subject(:service) { described_class.new(feedback, user).call }

  context 'when providing an user' do
    let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }
    let!(:prison) { create(:prison, name: 'HMP Bedford', sso_id: establishment_sso_id) }
    let(:permissions) { [{ 'organisation' => establishment_sso_id }] }
    let(:user) { User.new(permissions: permissions) }
    let(:requester) { { email: email, name: user.full_name } }
    let(:ticket_attrs) do
      {
        description: message,
        requester: requester,
        custom_fields: [
          { id: ZendeskTicketCreator::PRISON_FIELD, value: user.authorized_establishments.first.name },
          { id: ZendeskTicketCreator::SERVICE_FIELD, value: 'moving_people_safely' },
          { id: ZendeskTicketCreator::PRISONER_NUM_FIELD, value: prisoner_number }
        ]
      }
    end

    it 'invokes ZendeskAPI::Ticket.create! with the correct ticket attributes' do
      expect(ZendeskAPI::Ticket).to receive(:create!).with(Rails.configuration.zendesk_client, ticket_attrs)

      subject
    end
  end

  context 'when not providing an user' do
    let(:user) { nil }
    let(:requester) { { email: email, name: 'Unknown' } }
    let(:ticket_attrs) do
      {
        description: message,
        requester: requester,
        custom_fields: [
          { id: ZendeskTicketCreator::PRISON_FIELD, value: nil },
          { id: ZendeskTicketCreator::SERVICE_FIELD, value: 'moving_people_safely' },
          { id: ZendeskTicketCreator::PRISONER_NUM_FIELD, value: prisoner_number }
        ]
      }
    end

    it 'invokes ZendeskAPI::Ticket.create! with the correct ticket attributes' do
      expect(ZendeskAPI::Ticket).to receive(:create!).with(Rails.configuration.zendesk_client, ticket_attrs)

      subject
    end
  end

  context 'when Zendesk is not configured' do
    it 'raises an error' do
      expect(Rails.configuration).to receive(:zendesk_client).and_return(false)

      expect { subject }.to raise_error(ZendeskTicketCreator::ZendeskNotConfiguredError)
    end
  end
end
