#315

require 'rails_helper'

RSpec.describe 'Dashboard analytics', type: :request do
  before { sign_in FactoryGirl.create(:user) }

  describe "Date Change" do
    let(:date) { :foo }

    let(:event_data) do
      notification_payload_for('date_change') do
        post '/date', params: { commit: commit_value, date_picker: date }
      end
    end

    describe ":today" do
      let(:commit_value) { 'today' }

      it "should publish an analytics event" do
        expect(event_data).to eql new_date: :today
      end
    end

    describe ":back" do
      let(:commit_value) { '<' }

      it "should publish an analytics event" do
        expect(event_data).to eql new_date: :back
      end
    end

    describe ":forward" do
      let(:commit_value) { '>' }

      it "should publish an analytics event" do
        expect(event_data).to eql new_date: :forward
      end
    end

    describe "date input" do
      let(:commit_value) { 'Go' }

      it "should publish an analytics event" do
        expect(event_data).to eql new_date: date.to_s
      end
    end
  end

  def notification_payload_for(notification)
    payload = nil
    subscription = ActiveSupport::Notifications.subscribe notification do |name, start, finish, id, _payload|
      payload = _payload
    end

    yield

    ActiveSupport::Notifications.unsubscribe(subscription)

    return payload
  end
end
