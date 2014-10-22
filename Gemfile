source "https://rubygems.org"

gemspec

group :development, :test do
  gem "urb", :path => "."
end

group :test do
  gem "simplecov", :require => false
  gem "minitest"
  gem "mocha"
  gem "rack"
  gem "rack-minitest", :require => "rack-minitest/test", git: "git://github.com/brandonweiss/rack-minitest.git"
end
