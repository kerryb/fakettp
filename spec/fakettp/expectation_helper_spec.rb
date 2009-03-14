require File.dirname(__FILE__) + '/../spec_helper'

describe Fakettp::ExpectationHelper do
  describe 'calling expect' do
    describe 'when a matcher exception occurs' do
      it 'should raise an exception' do
        lambda {
          expect 'foo' do
            1.should == 2
          end
        }.should raise_error(Fakettp::Expectation::Error,
            /Error in foo: expected: 2,\s*got: 1/)
      end
    end
    
    describe 'when the block returns a value' do
      it 'should return the value' do
        result = expect 'foo' do
          'bar'
          # return 'bar' FIXME
        end
        result.should == 'bar'
      end
    end
  end
end
