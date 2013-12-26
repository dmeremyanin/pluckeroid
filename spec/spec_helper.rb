require 'rubygems'
require 'bundler/setup'

require 'pluckeroid'
require_relative 'support/schema'

RSpec.configure do |config|
  config.before(:suite) do
    Schema.create
  end
end
