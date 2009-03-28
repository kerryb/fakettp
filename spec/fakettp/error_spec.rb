require File.dirname(__FILE__) + '/../spec_helper'

# TODO: factor out persistence

describe Fakettp::Error do
  before :all do
    @error_dir = File.join FAKETTP_BASE, 'tmp', 'errors'
    FileUtils.mkdir_p @error_dir
  end

  describe 'clearing all errors' do
    before do
      FileUtils.touch File.join(@error_dir, '1-1')
    end
    
    it 'should remove the errors file' do
      Fakettp::Error.clear_all
      Dir.glob(File.join(@error_dir, '*')).should be_empty
    end
  end
  
  describe 'checking emptiness' do
    describe 'when errors files exist' do
      before do
        FileUtils.touch File.join(@error_dir, '1-1')
      end
      
      it 'should return false' do
        Fakettp::Error.should_not be_empty
      end
    end

    describe 'when no errors files exist' do
      before do
        FileUtils.rm_rf Dir.glob(File.join(@error_dir, '*'))
      end
      
      it 'should return false' do
        Fakettp::Error.should be_empty
      end
    end
  end
  
  describe 'adding an error' do      
    it 'should write the error message to the file' do
      Fakettp::Error.add 1, 2, 'foo'
      File.read(File.join(@error_dir, '1-2')).chomp.should == "foo"
    end
  end
  
  describe 'listing errors' do
    describe 'when error files exist' do
      before do
        FileUtils.rm_rf Dir.glob(File.join(@error_dir, '*'))
        File.open File.join(@error_dir, '1-2'), 'w' do |f|
          f.puts 'foo'
        end
        File.open File.join(@error_dir, '2-3'), 'w' do |f|
          f.puts 'bar'
        end
        
        @error_1 = stub :error_1
        @error_2 = stub :error_2
        Fakettp::Error.stub!(:new).with(1, 2, 'foo').and_return @error_1
        Fakettp::Error.stub!(:new).with(2, 3, 'bar').and_return @error_2
      end
      
      it 'should return an array containing the saved errors' do
        Fakettp::Error.list.should == [@error_1, @error_2]
      end
    end
    
    describe 'when the error file does not exist' do
      before do
        FileUtils.rm_rf Dir.glob(File.join(@error_dir, '*'))
      end
      
      it 'should return an empty array' do
        Fakettp::Error.list.should == []
      end
    end
  end
end
