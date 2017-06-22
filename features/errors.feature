Feature: Handling error responses

    Background:
        Given I am a client

    Scenario: Handle errors as a list
        When I request the error "list"
        Then the request fails because the post was not found
        And the response contains at least one errors
        And the response has one error
        And the response has one error with the attributes:
            | attribute   | type    | value     |
            | Message     | string  | Not Found |

    Scenario: Handle error as a single item
        When I request the error "single"
        Then the request fails because it was invalid
        And the response contains an error
        And the response has an error
        And the response has an error with the attributes:
            | attribute   | type    | value       |
            | Message     | string  | Bad Request |
