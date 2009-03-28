require File.dirname(__FILE__) + '/../spec_helper'

describe Fakettp::Expectation do
  before :all do
    @expectation_dir = File.join FAKETTP_BASE, 'tmp', 'expectations'
    FileUtils.mkdir_p @expectation_dir
  end
  
  def create_expectations count = 0
    Fakettp::Expectation.clear_all
    count.times do
      Fakettp::Expectation << ''
    end
  end
    
  describe 'clearing all expectations' do
    before do
      create_expectations 2
    end
    
    it 'should remove all expectations' do
      Fakettp::Expectation.clear_all
      Fakettp::Expectation.should be_all_received
    end
  end
  
  describe 'checking whether all expected requests have been received' do
    describe 'when there are no expectations' do
      before do
        create_expectations
      end
      
      it 'should return true' do
        Fakettp::Expectation.should be_all_received
      end
    end

    describe "when there are expectations that haven't been run" do
      before do
        create_expectations 1
      end
      
      it 'should return false' do
        Fakettp::Expectation.should_not be_all_received
      end
    end

    describe "when all expectations have been run" do
      before do
        create_expectations 1
        Fakettp::Expectation.next
      end
      
      it 'should return true' do
        Fakettp::Expectation.should be_all_received
      end
    end
  end
  
  describe 'getting all expectations' do
    it 'should return all expectations' do
      create_expectations 2
      expectations = Fakettp::Expectation.all
      expectations.size.should == 2
      expectations.should be_all { instance_of?(Fakettp::Expectation) }
    end
  end
  
  describe 'adding an expectation' do
    describe 'when there are existing expectations' do
      before do
        create_expectations 1
      end
    
      it 'should create a new expectation' do
        expectation = "foo\nbar"
        Fakettp::Expectation << expectation
        Fakettp::Expectation.next
        Fakettp::Expectation.next.id.should == 2
      end
    end
    
    describe 'when there are no existing expectations' do
      before do
        create_expectations
      end

      it 'should start at 1' do
        expectation = "foo\nbar"
        Fakettp::Expectation << expectation
        Fakettp::Expectation.next.id.should == 1
      end
    end
  end
  
  describe 'getting the next expectation' do
    describe 'when there are remaining expectations' do
      before do
        create_expectations
        @contents = "foo\nbar"
        Fakettp::Expectation << @contents
      end
  
      it 'should return an expectation with the correct contents' do
        expectation = stub :expectation
        Fakettp::Expectation.stub!(:new).with(1, @contents).and_return expectation
        Fakettp::Expectation.next.should == expectation
      end
    end

    describe 'when there are no remaining expectations' do
      before do
        Fakettp::Expectation.clear_all
      end
      
      it 'should raise an error' do
        lambda { Fakettp::Expectation.next }.should raise_error(Fakettp::Expectation::Error,
            'Received unexpected request')
      end
    end
    
    it 'should order expectations as integers, not strings' do
      create_expectations 11
      Fakettp::Expectation.next
      Fakettp::Expectation.next.id.should == 2
    end
  end
  
  it 'should allow access to its ID' do
    Fakettp::Expectation.new(1, 'foo').id.should == 1
  end
  
  describe 'rendering itself' do
    it 'should show its contents' do
      Fakettp::Expectation.new(1, 'foo').render.should == 'foo'
    end
  end
  
  describe 'executing' do
    it 'should eval the expectation code in the context of the supplied binding' do
      def getBinding(n)
        return binding
      end
      Fakettp::Expectation.new(1, 'n + 2').execute(getBinding(2)).should == 4
    end
  end
end
