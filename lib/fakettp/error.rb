module Fakettp
  class Error
    ERROR_FILE = File.join FAKETTP_BASE, 'errors'
    
    def self.clear_all
      FileUtils.rm_rf ERROR_FILE
    end
    
    def self.<< message
      File.open ERROR_FILE, 'a' do |f|
        f.puts message
      end
    end
    
    def self.empty?
      File.exists? ERROR_FILE
    end
  end
end
