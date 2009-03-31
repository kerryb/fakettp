require 'fakettp/expectation'
require 'fakettp/error'

module Fakettp
  class Simulator    
    def self.reset
      Expectation.delete_all
      Error.clear_all
    end
    
    def self.verify
      Error << 'Expected request not received' unless Expectation.all_received?
      Error.empty?
    end
    
    def self.<< expectation
      Expectation.create! :contents => expectation
    end
    
    def self.handle_request binding
      begin
        Expectation.next.execute binding
      rescue Fakettp::Expectation::Error => e
        Error << e.message
        raise e
      end
    end
    
    def self.list_errors
      Error.list
    end
  end
end