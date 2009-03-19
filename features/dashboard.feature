Feature: Dashboard for debugging failures
  Scenario: Dashboard web page served from /
    When we get / on fakettp.local
    Then the response should have a content type of 'text/html'
    And /html/head/title in the response should be 'FakeTTP'

  Scenario: Expectations are listed
    Given there are 3 expectations
    When we get / on fakettp.local
    Then the response should have a content type of 'text/html'
    And there should be 3 /html/body/div elements in the response
