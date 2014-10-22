module URB
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      if env["PATH_INFO"].match(/^#{URB::PATH}(\w+)?/)
        request = Rack::Request.new env
        path = request.get? ? URB.fetch($1) : request.params["path"]

        if path
          return [302, {"Location" => "#{URB::PATH}#{URB.store(path)}"}, ["Moved Temporarily"]] unless request.get?

          path, query_string = path.match(/^([^\?]+)\?(.*)$/).captures
          params = Rack::Utils.parse_nested_query query_string
          params.each{|key, value| request.update_param key, value}

          env["PATH_INFO"] = path
          env["REQUEST_URI"] = "#{env["HTTP_ORIGIN"]}#{path}?#{query_string}" if env["REQUEST_URI"]
          env["REQUEST_PATH"] = path if env["REQUEST_PATH"]
          env["ORIGINAL_FULLPATH"] = "#{path}?#{query_string}" if env["ORIGINAL_FULLPATH"]

        end
      end
      @app.call env
    end

  end
end
