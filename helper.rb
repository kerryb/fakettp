require 'spec'

ERROR_FILE = File.dirname(__FILE__) + '/tmp/errors'

def expect label
  begin
    yield
  rescue Exception => e
    File.open(ERROR_FILE, 'w') do |f|
      f.puts "Error in #{label}: #{e.message}\n\nRequest: #{request.inspect}"
    end
    throw :halt, [500, 'Simulator received unexpected request']
  end
end

def and_return
  yield
end

def run_expectation
  eval(File.read(File.dirname(__FILE__) + '/sample_expectation.rb'))
end

def reset_expectations
  File.open(ERROR_FILE, 'w') {|f|}
end

def verify_expectations
  errors = File.read ERROR_FILE
  throw :halt, [500, errors] unless errors.empty?
  'OK'
end
