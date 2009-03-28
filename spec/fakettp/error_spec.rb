require File.dirname(__FILE__) + '/../spec_helper'

describe Fakettp::Error do
  before :all do
    @error_file = File.join FAKETTP_BASE, 'tmp', 'errors'
    FileUtils.mkdir_p File.join(FAKETTP_BASE, 'tmp')
  end

  describe 'clearing all errors' do
    before do
      Fakettp::Error << 'foo'
    end
    
    it 'should remove the errors file' do
      Fakettp::Error.clear_all
      Fakettp::Error.should be_empty
    end
  end
  
  describe 'checking emptiness' do
    describe 'when errors exist' do
      before do
        Fakettp::Error << 'foo'
      end
      
      it 'should return false' do
        Fakettp::Error.should_not be_empty
      end
    end

    describe 'when errors do not exist' do
      before do
        Fakettp::Error.clear_all
      end
      
      it 'should return false' do
        Fakettp::Error.should be_empty
      end
    end
  end
  
  describe 'adding an error' do
    describe 'when errors already exist' do
      before do
        Fakettp::Error << 'foo'
      end
      
      it 'should append the new error message' do
        Fakettp::Error << 'bar'
        Fakettp::Error.list.should == "foo\nbar\n"
      end
    end
    
    describe 'when no errors already exist' do
      before do
        Fakettp::Error.clear_all
      end
      
      it 'should record the error message' do
        Fakettp::Error << 'bar'
        Fakettp::Error.list.should == "bar\n"
      end
    end
  end
  
  describe 'listing errors' do
    describe 'when errors exist' do
      before do
        Fakettp::Error.clear_all
        Fakettp::Error << 'foo'
      end
      
      it 'should return the error' do
        Fakettp::Error.list.should == "foo\n"
      end
    end
    
    describe 'when no errors exist' do
      before do
        Fakettp::Error.clear_all
      end
      
      it 'should return an empty string' do
        Fakettp::Error.list.should == ''
      end
    end
  end
end
