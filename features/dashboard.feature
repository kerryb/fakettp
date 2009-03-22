Feature: Dashboard for debugging failures
  Scenario: Dashboard web page served from /
    When we get / on fakettp.local
    Then the response should have a content type of 'text/html'
    And /html/head/title in the response should be 'FakeTTP'

  Scenario: Expectations are listed
    Given the simulator is reset
    And there are 3 expectations
    When we get / on fakettp.local
    Then there should be 3 /html/body/div elements in the response
    
  Scenario: Show expectation heading and contents
    Given the simulator is reset
    And we expect get_root
    When we get / on fakettp.local
    Then //h1[1] in the response should be '1'
    And //div[1]/pre in the response should be:
      """
      expect "GET /" do
        request.path_info.should == '/'
      end
      """
