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

get '/**' do
  content_type 'text/plain'
  run_expectation
end

run Sinatra.application
