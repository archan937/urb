require "securerandom"
require "moneta"

require "urb/middleware"
require "urb/engine" if defined?(Rails::Engine)
require "urb/version"

module URB
  extend self

  CHARS = [*0..9, *"A".."Z", *"a".."z"]
  PATH = "/-/"
  PREFIX = "@"
  MAXLENGTH = 2000

  def config(*args)
    @config = args
  end

  def fetch(key)
    paths[key]
  end

  def store(path)
    value = "#{PREFIX}#{path}"
    paths[value] || begin
      generate_key.tap do |key|
        paths[key] = path
        paths[value] = key
      end
    end
  end

private

  def paths
    @paths ||= Moneta.new *(@config || [:Memory])
  end

  def generate_key
    SecureRandom.urlsafe_base64(6).gsub(/[_-]/){ CHARS.sample }
  end

end

def URB(*args)
  URB.config *args
end