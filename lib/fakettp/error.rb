module Fakettp
  class Error < ActiveRecord::Base
    ERROR_FILE = File.join FAKETTP_BASE, 'tmp', 'errors'
        
    def self.list
      errors = Error.all
      return '' if errors.empty?
      errors.map {|e| e.message}.join("\n") + "\n"
    end
  end
end
