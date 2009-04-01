require 'fakettp/expectation'
require 'fakettp/error'

module Fakettp
  class Simulator    
    def self.reset
      Expectation.delete_all
      Error.delete_all
    end
    
    def self.verify
      Error.create!(:message => 'Expected request not received') unless Expectation.all_received?
      return !Error.exists?
    end
    
    def self.<< expectation
      Expectation.create! :contents => expectation
    end
    
    def self.handle_request binding
      begin
        Expectation.next.execute binding
      rescue Fakettp::Expectation::Error => e
        Error.create! :message => e.message
        raise e
      end
    end
    
    def self.list_errors
      Error.list
    end
  end
end