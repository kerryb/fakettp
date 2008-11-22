Feature: Mocking an HTTP server
  Scenario: No expectations and no requests
    Given the simulator is reset
    Then verifying the simulator should report success

  Scenario: One unsatisfied expectation
    Given the simulator is reset
    And we expect get_root
    Then verifying the simulator should report a failure, with message "Expected request not received"
  

  
