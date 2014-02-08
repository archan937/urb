require_relative "../../test_helper"

module Unit
  module Urb
    class TestMiddleware < Minitest::Test

      describe URB::Middleware do
        before do
          @key = "123abc"
          @path = "/foo/bar?very=long&query=string&foo[]=bar&foo[]=baz"
          @value = "#{URB::PREFIX}#{@path}"
        end

        describe "when value not stored yet" do
          it "stores the passed path, redirects to the 'key URL' and alters the request parameters" do
            URB.instance_variable_set :@paths, {}
            URB.expects(:generate_key).returns @key

            get "/"
            assert_equal "{}", last_response.body

            post URB::PATH, {:path => @path}
            assert_equal 302, last_response.status
            follow_redirect!

            assert_equal({
              "very" => "long", "query" => "string", "foo" => %w(bar baz)
            }.inspect, last_response.body)

            assert_equal({
              @key => @path,
              @value => @key
            }, URB.instance_variable_get(:@paths))
          end
        end

        describe "when value already stored" do
          it "alters the request parameters" do
            URB.instance_variable_set :@paths, {
              @key => @path,
              @value => @key
            }
            URB.expects(:generate_key).never

            get "#{URB::PATH}#{@key}"
            assert_equal({
              "very" => "long", "query" => "string", "foo" => %w(bar baz)
            }.inspect, last_response.body)

            assert_equal({
              @key => @path,
              @value => @key
            }, URB.instance_variable_get(:@paths))
          end
        end
      end

    end
  end
end

def app
  Rack::Builder.app do
    use URB::Middleware
    run lambda { |env|
      params = Rack::Request.new(env).params
      [200, {"Content-Type" => "text/plain"}, [params.inspect]]
    }
  end
end