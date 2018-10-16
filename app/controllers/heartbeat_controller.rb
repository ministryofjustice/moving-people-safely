# frozen_string_literal: true

require 'net/http'

class HeartbeatController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ping healthcheck]

  def ping
    json = {
      'build_date'      => ENV['APP_BUILD_DATE'] || 'Not Available',
      'commit_id'       => ENV['APP_GIT_COMMIT'] || 'Not Available',
      'build_tag'       => ENV['APP_BUILD_TAG'] || 'Not Available'
    }.to_json

    render json: json
  end

  def healthcheck
    checks = {
      database: database_connected?,
      'moj-sign-on': sso_ok?
    }

    status = checks.values.all? ? :ok : :bad_gateway
    render status: status, json: {
      checks: checks,
      healthy: checks.values.all? { |val| val == true }
    }
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.active?
  rescue PG::ConnectionBad
    false
  end

  def sso_ok?
    resp = Net::HTTP.get_response(URI(Rails.application.config.x.moj_sso_url))
    %w[200 302].include?(resp.code)
  rescue
    false
  end
end
