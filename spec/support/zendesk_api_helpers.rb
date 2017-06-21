module ZendeskApiHelpers
  def stub_zendesk_api_request
    stub_request(:post, "#{Rails.application.secrets[:zendesk_api]['url']}/tickets").
      to_return(status: 200, body: "", headers: {})
  end
end
