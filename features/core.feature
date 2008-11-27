Feature: Mocking an HTTP server
  Scenario: No expectations and no requests
    Given the simulator is reset
    Then verifying the simulator should report success

  Scenario: One unsatisfied expectation
    Given the simulator is reset
    And we expect get_root
    Then verifying the simulator should report a failure, with message "Expected request not received"

  Scenario: One satisfied expectation
    Given the simulator is reset
    And we expect get_root
    When we request /
    Then verifying the simulator should report success

  Scenario: Two satisfied expectations
    Given the simulator is reset
    And we expect get_root
    And we expect get_foo
    When we request /
    And we request /foo
    Then verifying the simulator should report success

  Scenario: Two expectations, one satisfied
    Given the simulator is reset
    And we expect get_root
    And we expect get_foo
    When we request /
    Then verifying the simulator should report a failure, with message "Expected request not received"

  Scenario: Expectation failure
    Given the simulator is reset
    And we expect get_root
    When we request /foo
    Then verifying the simulator should report a failure, with message "Error in GET /: expected: "/",.*got: "/foo""
