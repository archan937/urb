module URB
  class Engine < Rails::Engine

    initializer "urb.add_middleware" do |app|
      app.middleware.insert 0, URB::Middleware
    end

  end
end