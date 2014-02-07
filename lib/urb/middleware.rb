module URB
  class Middleware

    def initialize(app, *config)
      @app = app
      URB *config unless config.blank?
    end

    def call(env)

      # env["HTTP_HOST"] = "localhost:3000"
      # env["HTTP_ORIGIN"] = "http://localhost:3000"
      # env["REQUEST_METHOD"] = "GET"
      # env["REQUEST_URI"] = "http://localhost:3000/-/?asdf"
      # env["REQUEST_PATH"] = "/-/"
      # env["ORIGINAL_FULLPATH"] = "/-/?asdf"
      # env["PATH_INFO"] = "/-/"
      # Rack::Request.new(env).params
      # env["rack.request.form_hash"] = {"url" => "http://apple.com"}
      # env["rack.request.form_vars"] = "url=http%3A%2F%2Fapple.com"}

      if env["REQUEST_PATH"].match(/^\/-\/(\w+)/)
        if url = env["REQUEST_METHOD"] == "GET" ? URB.fetch($1) : Rack::Request.new(env).params["url"]

          if env["REQUEST_METHOD"] == "POST"
            URB.store url, $1
            env["REQUEST_METHOD"] = "GET"
            env["rack.request.form_hash"] = nil
            env["rack.request.form_vars"] = nil
          end

          path, query_string = url.match(/^([^\?]+)\?(.*)$/).captures

          env["REQUEST_URI"] = "#{env["HTTP_ORIGIN"]}#{path}?#{query_string}"
          env["REQUEST_PATH"] = path
          env["ORIGINAL_FULLPATH"] = "#{path}?#{query_string}"
          env["PATH_INFO"] = path
          env["action_dispatch.request.request_parameters"] = Rack::Utils.parse_nested_query(query_string)

        end
      end

      @app.call env

    end

  end
end