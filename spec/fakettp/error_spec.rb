require File.dirname(__FILE__) + '/../spec_helper'

describe Fakettp::Error do
  before do
    Fakettp::Error.delete_all
  end
  
  it 'should be an ActiveRecord' do
    Fakettp::Error.new.should be_a_kind_of(ActiveRecord::Base)
  end
  
  it 'should store a message' do
    Fakettp::Error.create(:message => 'foo').message.should == 'foo'
  end
  
  describe 'listing errors' do
    describe 'when errors exist' do
      before do
        Fakettp::Error.create! :message => 'foo'
        Fakettp::Error.create! :message => 'bar'
      end
      
      it 'should return the concatenated error messages' do
        Fakettp::Error.list.should == "foo\nbar\n"
      end
    end
    
    describe 'when no errors exist' do
      before do
        Fakettp::Error.delete_all
      end
      
      it 'should return an empty string' do
        Fakettp::Error.list.should == ''
      end
    end
  end
end
