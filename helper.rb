require 'spec'

TMP_DIR = File.dirname(__FILE__) + '/tmp'
ERROR_FILE = "#{TMP_DIR}/errors"
EXPECTATION_DIR = "#{TMP_DIR}/expectations"

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

# Note: client *must* send a Content-Type header of 'text/plain'. Probably.
def set_expectation
  content_type 'text/plain'
  expectation = request.body.read
  File.open(next_expectation_file, 'w') do |f|
    f.write expectation
  end
end

def run_expectation
  content_type 'text/plain'
  eval(File.read(EXPECTATION_DIR + '/1.rb'))
end

def reset_expectations
  content_type 'text/plain'
  FileUtils.rm_f(Dir.glob(EXPECTATION_DIR + '/*'))
  File.open(ERROR_FILE, 'w') {|f|}
end

def verify_expectations
  content_type 'text/plain'
  errors = File.read ERROR_FILE
  throw :halt, [400, errors] unless errors.empty?
  'OK'
end

private

def next_expectation_file
  files = Dir.glob(EXPECTATION_DIR + '/*.rb').sort
  if files.empty?
    "#{EXPECTATION_DIR}/1.rb"
  else
    "#{EXPECTATION_DIR}/#{File.basename(files.last, '.rb').to_i + 1}.rb"
  end
end