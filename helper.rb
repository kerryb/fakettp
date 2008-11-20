require 'spec'

def expect
  begin
    yield
  rescue Exception => e
    throw :halt, [400, e.message + "\n\nRequest: #{request.inspect}"]
  end
end

def and_return
  yield
end

def run_expectation
  eval(File.read(File.dirname(__FILE__) + '/sample_expectation.rb'))
end