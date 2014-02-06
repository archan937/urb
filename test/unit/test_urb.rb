require_relative "../test_helper"

module Unit
  class TestURB < MiniTest::Unit::TestCase

    describe URB do
      before do
        URB.instance_variable_set :@config, nil
        URB.instance_variable_set :@urls, nil
      end

      describe ".URB" do
        it "delegates to URB.config" do
          URB.expects(:config).with(:foo, :bar)
          URB :foo, :bar
        end
      end

      describe ".config" do
        it "memoizes its Moneta backend configuration" do
          URB.config :File, :dir => "moneta"
          assert_equal [:File, :dir => "moneta"], URB.instance_variable_get(:@config)
        end
      end

      describe ".urls" do
        describe "not configured" do
          it "returns an in-memory Moneta store instance" do
            store = mock
            Moneta.expects(:new).with(:Memory).returns(store)
            assert_equal store, URB.send(:urls)
          end
        end
        describe "configured" do
          before do
            URB.instance_variable_set :@config, [:Foo, :bar => "baz"]
          end
          it "returns an in-memory Moneta store instance" do
            store = mock
            Moneta.expects(:new).with(:Foo, :bar => "baz").returns(store)
            assert_equal store, URB.send(:urls)
          end
        end
        it "memoizes its Moneta store" do
          assert_equal URB.send(:urls).object_id, URB.send(:urls).object_id
        end
      end

      describe ".generate_key" do
        it "generates a unique key" do
          keys = (1..250000).to_a.collect{URB.send(:generate_key)}
          assert_equal 250000, keys.uniq.size
        end
      end

      describe ".store" do
        it "stores a passed URL in the Moneta store" do
          urls, key, url = mock, "abc123", "/foo?bar=baz"
          URB.expects(:generate_key).returns(key)
          URB.expects(:urls).returns(urls)
          urls.expects(:[]=).with(key, url)
          assert_equal key, URB.store(url)
        end
      end

      describe ".fetch" do
        it "returns the stored URL in the Moneta store" do
          urls = {"abc" => "/foo", "123" => "/bar"}
          URB.expects(:urls).at_least_once.returns(urls)
          assert_equal "/foo", URB.fetch("abc")
          assert_equal "/bar", URB.fetch("123")
        end
      end
    end

  end
end