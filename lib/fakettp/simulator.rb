require 'fakettp/expectation'
require 'fakettp/error'

module Fakettp
  class Simulator    
    def self.reset
      Expectation.clear_all
      Error.clear_all
    end
    
    def self.verify
      Error.add 0, 0, 'Expected request not received' unless Expectation.all_received?
      Error.empty?
    end
    
    def self.<< expectation
      Expectation << expectation
    end
    
    def self.handle_request binding
      begin
        Expectation.next.execute binding
      rescue Fakettp::Expectation::Error => e
        Error.add e.expectation, e.line_no, e.message
        raise e
      end
    end
    
    def self.list_errors
      Error.list
    end
  end
end