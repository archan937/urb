require_relative "../test_helper"

module Unit
  class TestURB < Minitest::Test

    describe URB do
      before do
        URB.instance_variable_set :@config, nil
        URB.instance_variable_set :@paths, nil
      end

      describe "URB::VERSION" do
        it "has the current version" do
          version = File.read(File.expand_path("../../../VERSION", __FILE__)).strip
          assert_equal version, URB::VERSION
          assert File.read(File.expand_path("../../../CHANGELOG.rdoc", __FILE__)).include?("Version #{version}")
        end
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

      describe ".paths" do
        describe "not configured" do
          it "returns an in-memory Moneta store instance" do
            store = mock
            Moneta.expects(:new).with(:Memory).returns(store)
            assert_equal store, URB.send(:paths)
          end
        end
        describe "configured" do
          before do
            URB.instance_variable_set :@config, [:Foo, :bar => "baz"]
          end
          it "returns an in-memory Moneta store instance" do
            store = mock
            Moneta.expects(:new).with(:Foo, :bar => "baz").returns(store)
            assert_equal store, URB.send(:paths)
          end
        end
        it "memoizes its Moneta store" do
          assert_equal URB.send(:paths).object_id, URB.send(:paths).object_id
        end
      end

      describe ".generate_key" do
        it "generates a unique key" do
          keys = (1..250000).to_a.collect{URB.send(:generate_key)}
          assert_equal 250000, keys.uniq.size
        end
      end

      describe ".store" do
        before do
          @key = "abc123"
          @path = "/foo?bar=baz"
          @value = "#{URB::PREFIX}#{@path}"
        end
        describe "when value not stored yet" do
          it "stores the passed path in the Moneta store and returns the generated key" do
            paths = {}

            URB.expects(:paths).at_least_once.returns(paths)
            URB.expects(:generate_key).returns(@key)

            assert_equal @key, URB.store(@path)
            assert_equal({
              @key => @path,
              @value => @key
            }, paths)
          end
        end
        describe "when value already stored" do
          it "returns the key of the already stored value" do
            paths = {
              @key => @path,
              @value => @key
            }

            URB.expects(:paths).at_least_once.returns(paths)
            URB.expects(:generate_key).never

            assert_equal @key, URB.store(@path)
            assert_equal({
              @key => @path,
              @value => @key
            }, paths)
          end
        end
      end

      describe ".fetch" do
        it "returns the stored path in the Moneta store" do
          paths = {"abc" => "/foo", "123" => "/bar"}
          URB.expects(:paths).at_least_once.returns(paths)
          assert_equal "/foo", URB.fetch("abc")
          assert_equal "/bar", URB.fetch("123")
        end
      end
    end

  end
end
