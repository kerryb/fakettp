Feature: Dashboard for debugging failures
  Scenario: Viewing the dashboard
    When we get / on fakettp.local
    Then the response should have a content type of 'text/html'
    And /html/title in the response should be 'FakeTTP'
