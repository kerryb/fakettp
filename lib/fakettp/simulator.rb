module Fakettp
  class Simulator    
    def self.reset
      Expectation.clear_all
      Error.clear_all
    end
    
    def self.verify
      Error << 'Expected request not received' unless Expectation.empty?
      Error.empty?
    end
    
    def self.<< expectation
      Expectation << expectation
    end
    
    def self.handle_request
      Expectation.next.execute
    end
    
    def self.record_error exception
      Error << exception.message
    end
    
    def self.list_errors
      Error.list
    end
  end
end