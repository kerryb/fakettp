Feature: Verification of expectations
  Scenario: No expectations and no requests
    Given the simulator is reset
    Then verifying the simulator should report success

  Scenario: Satisfied expectation
    Given the simulator is reset
    And we expect get_root
    When we get / on foo.fake.local
    Then verifying the simulator should report success

  Scenario: Unsatisfied expectation
    Given the simulator is reset
    And we expect get_root
    Then verifying the simulator should report a failure, with message "Expected request not received"

  Scenario: Unexpected request
    Given the simulator is reset
    When we get / on foo.fake.local
    Then verifying the simulator should report a failure, with message "Received unexpected request"

  Scenario: Mismatched expectation
    Given the simulator is reset
    And we expect get_root
    When we get /foo on foo.fake.local
    Then verifying the simulator should report a failure, with message "Error in GET /: expected: "/",.*got: "/foo""

  Scenario: Two satisfied expectations
    Given the simulator is reset
    And we expect get_root
    And we expect get_foo
    When we get / on foo.fake.local
    And we get /foo on foo.fake.local
    Then verifying the simulator should report success

  Scenario: Two expectations, one satisfied
    Given the simulator is reset
    And we expect get_root
    And we expect get_foo
    When we get / on foo.fake.local
    Then verifying the simulator should report a failure, with message "Expected request not received"

  Scenario: Two expectations, with requests received in the wrong order
    Given the simulator is reset
    And we expect get_root
    And we expect get_foo
    When we get /foo on foo.fake.local
    And we get / on foo.fake.local
    Then verifying the simulator should report a failure, with message "Error in GET /: expected: "/",.*got: "/foo".*Error in GET /foo: expected: "/foo",.*got: "/""
