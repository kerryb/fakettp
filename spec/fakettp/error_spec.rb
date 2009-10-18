require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Fakettp::Error do
  before do
    Fakettp::Error.delete_all
  end
  
  it 'is an ActiveRecord' do
    Fakettp::Error.new.should be_a_kind_of(ActiveRecord::Base)
  end
  
  it { should have_db_column(:message).of_type(:text) }

  it { should have_db_column(:line_number).of_type(:integer) }
  
  it { should belong_to(:expectation) }
  
  describe 'listing errors' do
    describe 'when errors exist' do
      before do
        Fakettp::Error.create! :message => 'foo'
        Fakettp::Error.create! :message => 'bar'
      end
      
      it 'returns the concatenated error messages' do
        Fakettp::Error.list.should == "foo\nbar\n"
      end
    end
    
    describe 'when no errors exist' do
      before do
        Fakettp::Error.delete_all
      end
      
      it 'returns an empty string' do
        Fakettp::Error.list.should == ''
      end
    end
  end
end
