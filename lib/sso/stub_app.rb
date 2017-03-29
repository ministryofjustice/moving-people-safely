module SSO
  class StubApp
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when '/users/sign_out', '/profile'
        json = '{ "success" : true }'
        Rack::Response.new(json, 200, 'Content-Type' => 'application/json')
      else
        app.call(env)
      end
    end

    private

    attr_reader :app
  end
end
