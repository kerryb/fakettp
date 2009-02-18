module Fakettp
  class Simulator
    def self.reset
      Expectation.clear_all
      Error.clear_all
    end
    
    def self.verify
    end
    
    def self.<< expectation
    end
    
    def self.list_errors
    end
  end
end