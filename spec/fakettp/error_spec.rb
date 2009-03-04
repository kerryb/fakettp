require File.dirname(__FILE__) + '/../spec_helper'

describe Fakettp::Error do
  before :all do
    @error_file = File.join FAKETTP_BASE, 'errors'
  end

  describe 'clearing all errors' do
    before do
      FileUtils.touch @error_file
    end
    
    it 'should remove the errors file' do
      Fakettp::Error.clear_all
      File.exists?(@error_file).should be_false
    end
  end
  
  describe 'checking emptiness' do
    describe 'when the errors file exists' do
      before do
        FileUtils.touch @error_file
      end
      
      it 'should return true' do
        Fakettp::Error.should be_empty
      end
    end

    describe 'when the errors file does not exist' do
      before do
        FileUtils.rm_rf @error_file
      end
      
      it 'should return false' do
        Fakettp::Error.should_not be_empty
      end
    end
  end
  
  describe 'adding an error' do
    describe 'when the error file already exists' do
      before do
        File.open @error_file, 'w' do |f|
          f.puts 'foo'
        end
      end
      
      it 'should append the error message to the file' do
        Fakettp::Error << 'bar'
        File.read(@error_file).should == "foo\nbar\n"
      end
    end
    
    describe 'when the error file does not exist' do
      before do
        FileUtils.rm_rf @error_file
      end
      
      it 'should create the file and write the error message to it' do
        Fakettp::Error << 'bar'
        File.read(@error_file).should == "bar\n"
      end
    end
  end
  
  describe 'listing errors' do
    it 'should have behaviour'
  end
end
