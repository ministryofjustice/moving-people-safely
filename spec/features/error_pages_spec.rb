require 'feature_helper'

RSpec.feature 'error pages', type: :feature do
  before do
    method = Rails.application.method(:env_config)
    allow(Rails.application).to receive(:env_config).with(no_args) do
      method.call.merge(
        'action_dispatch.show_exceptions' => true,
        'action_dispatch.show_detailed_exceptions' => false,
        'consider_all_requests_local' => false
      )
    end
  end

  scenario 'user requests a non existent page' do
    visit '/wrong'

    expect(page).to have_content('Page not found')
  end

  scenario 'user visits a page that raises an error' do
    allow(Forms::Feedback).to receive(:new).and_raise

    visit new_feedback_path

    expect(page).to have_content('Sorry, there is a problem with the service')
  end
end
