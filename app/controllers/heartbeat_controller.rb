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
      database: database_connected?
    }

    status = checks.values.all? ? :ok : :bad_gateway
    render status: status, json: {
      checks: checks
    }
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.active?
  rescue PG::ConnectionBad
    false
  end
end
