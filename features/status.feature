Feature: I can handle different response codes

    Background:
        Given I am a client

    Scenario: Successful response
        When I request the post "1"
        Then the request is successful

    Scenario: Key not found
        When I request the post "not-found"
        Then the request fails
        And it fails because the post was not found

    Scenario: Resource not found
        When I request the Not Found "5"
        Then the request fails
        And it fails because the not found was not found
