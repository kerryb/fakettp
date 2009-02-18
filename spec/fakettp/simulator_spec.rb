require File.dirname(__FILE__) + '/../spec_helper'

describe Fakettp::Simulator do
  before do
    Fakettp::Expectation.stub! :clear_all
    Fakettp::Error.stub! :clear_all
  end
  
  describe "resetting" do
    it 'should clear expectations' do
      Fakettp::Expectation.should_receive :clear_all
      Fakettp::Simulator.reset
    end
    
    it 'should clear errors' do
      Fakettp::Error.should_receive :clear_all
      Fakettp::Simulator.reset
    end
  end
end
