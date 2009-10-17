require File.dirname(__FILE__) + '/../spec_helper'

describe Fakettp::Simulator do
  before do
    Fakettp::Expectation.stub! :clear_all
    Fakettp::Error.stub! :clear_all
  end
  
  describe "resetting" do
    def do_reset
      Fakettp::Simulator.reset
    end
    
    it 'clears expectations' do
      Fakettp::Expectation.should_receive :clear_all
      do_reset
    end
    
    it 'clears errors' do
      Fakettp::Error.should_receive :clear_all
      do_reset
    end
  end
  
  describe 'adding an expectation' do
    before do
      @expectation = stub(:expectation)
    end
    
    def do_add
      Fakettp::Simulator << @expectation
    end
    
    it 'creates a new expectation' do
      Fakettp::Expectation.should_receive(:<<).with @expectation
      do_add
    end
  end
  
  describe 'handling a request' do
    before do
      @binding = stub :binding
      @result = 'foo'
      @expectation = mock Fakettp::Expectation, :execute => @result
      Fakettp::Expectation.stub!(:next).and_return @expectation
    end
    
    def do_handle
      Fakettp::Simulator.handle_request @binding
    end
    
    it 'executes the next request' do
      @expectation.should_receive(:execute).with @binding
      do_handle
    end
    
    it 'returns the execution result' do
      do_handle.should == @result
    end
    
    describe 'when an expectation error occurs' do
      before do
        @expectation.stub!(:execute).and_raise Fakettp::Expectation::Error.new('foo')
        Fakettp::Error.stub!(:<<)
      end
      
      it 'records the error' do
        Fakettp::Error.should_receive(:<<).with 'foo'
        begin
          do_handle
        rescue Fakettp::Expectation::Error;end
      end
      
      it 'res-raise the exception' do
        lambda {do_handle}.should raise_error(Fakettp::Expectation::Error, 'foo')
      end
    end
  end
  
  describe "verifying" do
    def do_verify
      Fakettp::Simulator.verify
    end
    
    describe 'when there are pending expectations' do
      before do
        Fakettp::Expectation.stub!(:empty?).and_return true
      end
      
      describe 'when there are no errors' do
        before do
          Fakettp::Error.stub!(:empty?).and_return true
        end
      
        it { do_verify.should be_true }
      end
    
      describe 'when there are errors' do
        before do
          Fakettp::Error.stub!(:empty?).and_return false
        end
      
        it { do_verify.should be_false }
      end
    end
    
    describe 'when there are pending expectations' do
      before do
        Fakettp::Expectation.stub!(:empty?).and_return false
      end
      
      it 'adds an error' do
        Fakettp::Error.should_receive(:<<).with 'Expected request not received'
        do_verify
      end

      it { do_verify.should be_false }
    end
  end
  
  describe 'listing errors' do
    before do
      @errors = stub :errors
      Fakettp::Error.stub!(:list).and_return @errors
    end
    
    it 'returns the error list' do
      Fakettp::Simulator.list_errors.should == @errors
    end
  end
end
