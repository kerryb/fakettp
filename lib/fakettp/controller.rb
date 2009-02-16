require 'sinatra'
Sinatra::Default.set :run, false
Sinatra::Default.set :environment, ENV['RACK_ENV']

error do
  request.env['sinatra.error'].inspect
end

post '/expect' do
  set_expectation
end

post '/reset' do
  reset_expectations
end

get '/verify' do
  verify_expectations
end

[:get, :post, :put, :delete, :head].each do |method|
  send method, '/**' do
    run_expectation
  end
end