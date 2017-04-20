class PingController < ActionController::Base
  def show
    render json: version_info
  end

  private

  def version_info
    {
      build_date: ENV.fetch('APP_BUILD_DATE'),
      build_tag: ENV.fetch('APP_BUILD_TAG'),
      commit: ENV.fetch('APP_GIT_COMMIT')
    }
  rescue KeyError
    {}
  end
end
