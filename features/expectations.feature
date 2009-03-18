Feature: Expectations
  Scenario: Using rspec matchers
    Given the simulator is reset
    And we expect expect_get
    And we get / on foo.fake.local
    Then verifying the simulator should report success
    
  Scenario: Setting response headers
    Given the simulator is reset
    And we expect set_response
    And we get / on foo.fake.local
    Then the response should have a 'foo' header with a value of 'bar'
    And verifying the simulator should report success
    
  Scenario: Setting response content-type
    Given the simulator is reset
    And we expect set_response
    And we get / on foo.fake.local
    Then the response should have a content type of 'application/xml'
    And verifying the simulator should report success
    
  Scenario: Setting response code
    Given the simulator is reset
    And we expect set_response
    And we get / on foo.fake.local
    Then the response body should be '<foo />'
    And verifying the simulator should report success
