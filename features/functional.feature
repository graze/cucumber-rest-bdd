Feature: Performing different rest methods

    Background:
        Given I am a client

    Scenario: Count the number of elements
        When I request a list of posts with:
            | User Id | 8 |
        Then the request is successful
        And the JSON response should have "$." of type array with 10 entries
