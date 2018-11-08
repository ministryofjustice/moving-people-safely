# frozen_string_literal: true

module Detainees
  class ScheduledMoveFetcher < BaseFetcher
    def call
      with_error_handling do
        return empty_response unless prison_number.present?

        fetch_scheduled_move
        successful_response(mapped_scheduled_move)
      end
    end

    private

    def fetch_scheduled_move
      log_api_request "Requesting alerts for offender with NOMS id #{prison_number}"
      @response = api_client.get("/offenders/#{prison_number}/alerts")
    end

    def mapped_scheduled_move
      ScheduledMoveMapper.new(response).call
    end
  end
end
