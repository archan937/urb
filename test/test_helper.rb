$:.unshift File.expand_path("../../lib", __FILE__)

require_relative "test_helper/coverage"

require "minitest/autorun"
require "mocha/setup"

require "bundler"
Bundler.require :default, :development, :test