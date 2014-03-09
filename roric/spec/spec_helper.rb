if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "vendor/bundle"
  end
end

require 'roric'
require 'rspec/autorun'
require 'pry'

files = Dir.glob(File.expand_path("support/**/*.rb", File.dirname(__FILE__)))

files.each {|f| require f }

RSpec.configure do |config|
  config.order = "random"
end
