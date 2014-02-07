require "securerandom"
require "moneta"

require "urb/middleware"
require "urb/engine" if defined?(Rails::Engine)
require "urb/version"

module URB
  extend self

  def config(*args)
    @config = args
  end

  def fetch(key)
    urls[key]
  end

  def store(url, key = nil)
    (key || generate_key).tap do |key|
      urls[key] = url
    end
  end

private

  def urls
    @urls ||= Moneta.new *(@config || [:Memory])
  end

  def generate_key
    SecureRandom.urlsafe_base64(8).gsub /[_-]/, ""
  end

end

def URB(*args)
  URB.config *args
end