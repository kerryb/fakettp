require 'fakettp/expectation'

module Fakettp
  module ExpectationHelper
    def expect label
      begin
        yield
      rescue Exception => e
        raise Fakettp::Expectation::Error.new("Error in #{label}: #{e.message}")
      end
    end
  end
end
