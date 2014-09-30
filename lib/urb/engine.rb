module URB
  class Engine < Rails::Engine

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w(urb/urb.js)
    end

    initializer "urb.add_middleware" do |app|
      app.middleware.insert 0, URB::Middleware
    end

  end
end
