require File.dirname(__FILE__) + '/../spec_helper'
require 'fakettp/controller'

describe 'Controller' do
  describe 'posting to /delete' do
    it 'should be successful' do
      post '/delete'
      @response.should be_ok
    end
  end
end
