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
    
    it 'should clear expectations' do
      Fakettp::Expectation.should_receive :clear_all
      do_reset
    end
    
    it 'should clear errors' do
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
    
    it 'should create a new expectation' do
      Fakettp::Expectation.should_receive(:create).with @expectation
      do_add
    end
  end
  
  describe "verifying" do
    def do_verify
      Fakettp::Simulator.verify
    end
    
    describe 'when there are no errors' do
      before do
        Fakettp::Error.stub!(:list).and_return []
      end
      
      it { do_verify.should be_true }
    end
    
    describe 'when there are errors' do
      before do
        Fakettp::Error.stub!(:list).and_return [stub(:error)]
      end
      
      it { do_verify.should be_false }
    end
  end
end
