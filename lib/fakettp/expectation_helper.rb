require 'fakettp/expectation'

module Fakettp
  module ExpectationHelper
    def self.included(cls)
      cls.send :include, Spec::Matchers
    end
  
    def expect label
      begin
        yield
      rescue Exception => e
        raise Fakettp::Expectation::Error.new("Error in #{label}: #{e.message}")
      end
    end
  end
end
