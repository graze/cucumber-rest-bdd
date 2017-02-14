Feature: Performing different rest methods

    Background:
        Given I am a client

    Scenario: Count the number of elements
        When I request a list of posts with:
            | User Id | 8 |
        Then the request is successful
        And the JSON response should have "$." of type array with at least 1 entry
        And the JSON response should have "$." of type array with at least 10 entries
        And the JSON response should have "$." of type array with 10 entries
        And the JSON response should have "$." of type array with at most 10 entries
        And the JSON response should have "$." of type array with at most 11 entries

    Scenario: Check for null type
        When I request to create a post with:
            | attribute | type     | value               |
            | title     | string   | foo                 |
            | body      | text     | bar                 |
            | null      | null     |                     |
            | nil       | nil      |                     |
        Then the JSON response should have "null" of type null
        Then the JSON response should have "nil" of type nil
        Then the JSON response should have "nil" of type nill
