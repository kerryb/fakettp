require 'rubygems'
require 'sinatra'
require 'helper'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => ENV['RACK_ENV']
)

error do
  content_type 'text/plain'
  request.env['sinatra.error'].inspect
end

post '/reset' do
  reset_expectations
end

get '/verify' do
  content_type 'text/plain'
  verify_expectations
end

get '/**' do
  content_type 'text/plain'
  run_expectation
end

run Sinatra.application
