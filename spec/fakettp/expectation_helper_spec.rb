require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Fakettp::ExpectationHelper do
  it 'mixes in Spec::Matchers' do
    class Foo
      include Fakettp::ExpectationHelper
    end
    
    Foo.included_modules.should include(Spec::Matchers)
  end
  
  describe 'calling expect' do
    describe 'when a matcher exception occurs' do
      it 'raises an exception' do
        lambda {
          Fakettp::ExpectationHelper.expect 'foo' do
            1.should == 2
          end
        }.should raise_error(Fakettp::Expectation::Error,
            /Error in foo: expected: 2,\s*got: 1/)
      end
    end
    
    describe 'when the block returns a value' do
      it 'returns the value' do
        result = Fakettp::ExpectationHelper.expect 'foo' do
          'bar'
        end
        result.should == 'bar'
      end
    end
  end
end
