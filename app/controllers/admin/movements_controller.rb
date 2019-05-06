# frozen_string_literal: true

require 'nomis_auth/client'
require 'custody_api/client'

module Admin
  class MovementsController < ApplicationController
    before_action :authorize_admin!
    before_action :require_noms_id, only: :show

    def new; end

    def show
      @noms_id = noms_id
      @offender = offender_details
      if @offender.present?
        @movements = offender_movements
      else
        flash[:error] = t 'alerts.detainee.details.not_found'
        @movements = []
      end
    end

    private

    def require_noms_id
      return if noms_id.present?

      redirect_to new_admin_movements_path
    end

    def noms_id
      params[:noms_id]
    end

    def offender_id
      offender_details['offenderId']
    end

    def offender_details
      @_offender_details ||= begin
        resp = custody_client.get("api/offenders/nomsId/#{noms_id}")
        # unless resp.success?
        #   raise "problem getting from api #{resp.body}"
        # end
        resp.body
      end
    end

    def offender_movements
      @_offender_movements ||= begin
        resp = custody_client.get("api/offenders/offenderId/#{offender_id}/movements")
        raise "problem getting from api #{resp.body}" unless resp.success?

        resp.body
      end
    end

    def custody_token
      @_custody_token ||= begin
        auth = NomisAuth::Client.new(
          host: ENV.fetch('NOMIS_AUTH_HOST'),
          client_id: ENV.fetch('NOMIS_AUTH_CLIENT_ID'),
          client_secret: ENV.fetch('NOMIS_AUTH_CLIENT_SECRET')
        )
        auth.token
      end
    end

    def custody_client
      @_custody_client ||= CustodyApi::Client.new(
        host: ENV.fetch('CUSTODY_API_HOST'),
        token: custody_token
      )
    end
  end
end
