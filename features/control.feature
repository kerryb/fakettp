Feature: Controlling the simulator
  Scenario: Attempting to reset the simulator using the wrong host
    When we post to /reset on foo.fakettp.fake.local
    Then the response body should contain 'Simulator received mismatched request'

  Scenario: Attempting to create an expectation using the wrong host
    When we post to /expect on foo.fakettp.fake.local
    Then the response body should contain 'Simulator received mismatched request'

  Scenario: Attempting to verify the simulator using the wrong host
    When we get /verify on foo.fakettp.fake.local
    Then the response body should contain 'Simulator received mismatched request'
