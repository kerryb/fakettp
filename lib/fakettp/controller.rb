require 'sinatra'
require 'spec'
Sinatra::Default.set :run, false
Sinatra::Default.set :environment, ENV['RACK_ENV']

require 'fakettp/expectation_helper'
require 'fakettp/simulator'
require 'fakettp/expectation'

set :views, File.join(File.dirname(__FILE__), 'views')

config_file = File.join(FAKETTP_BASE, 'fakettp.yml')
config = File.read config_file
host = YAML.load(config)['hostname']

include Fakettp::ExpectationHelper

send :post, '/expect', :host => host do
  Fakettp::Simulator << request.body.read
  content_type 'text/plain'
  "Expect OK\n"
end

send :post, '/reset', :host => host do
  Fakettp::Simulator.reset
  content_type 'text/plain'
  "Reset OK\n"
end

send :get, '/verify', :host => host do
  content_type 'text/plain'
  if Fakettp::Simulator.verify
    "Verify OK\n"
  else
    throw :halt, [500, Fakettp::Simulator.list_errors]
  end
end

send :get, '/', :host => host do
  content_type 'text/html'
  @expectations = Fakettp::Expectation.all
  erb :index
end

[:get, :post, :put, :delete, :head].each do |method|
  send method, '/**' do
    begin
      Fakettp::Simulator.handle_request binding
    rescue Fakettp::Expectation::Error => e
      content_type 'text/plain'
      throw :halt, [500, "Simulator received mismatched request\n"]
    end
  end
end
