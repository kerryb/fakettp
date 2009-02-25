module Fakettp
  class Expectation
    EXPECTATION_DIR = FAKETTP_BASE + '/expectations'
    def self.clear_all
      FileUtils.rm_rf Dir.glob(File.join(EXPECTATION_DIR, '*'))
    end
    
    def self.<< expectation
      File.open next_file_to_create, 'w' do |f|
        f.write expectation
      end
    end
    
    def self.next
      file = next_file_to_read
      contents = File.read file
      FileUtils.rm file
      contents
    end

    
    def self.next_file_to_create
      name = (Dir.entries(EXPECTATION_DIR).last.to_i + 1).to_s
      File.join EXPECTATION_DIR, name
    end
    
    def self.next_file_to_read
      name = Dir.entries(EXPECTATION_DIR)[2] # ignore . and ..
      File.join EXPECTATION_DIR, name
    end
  
    private_class_method :next_file_to_create, :next_file_to_read
  end
end
