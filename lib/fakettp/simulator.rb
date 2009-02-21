module Fakettp
  class Simulator
    def self.reset
      Expectation.clear_all
      Error.clear_all
    end
    
    def self.verify
      Error.list.empty?
    end
    
    def self.<< expectation
      Expectation.create expectation
    end
    
    def self.run_expectation
    end
    
    def self.list_errors
    end
  end
end