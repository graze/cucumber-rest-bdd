Feature: Using the response from a previous request

    Background:
        Given I am a client

    Scenario: Get an id from creation and use in get
        When I request to create a post with:
            | attribute | type    | value |
            | Title     | string  | foo   |
            | Body      | string  | bar   |
            | User Id   | integer | 12    |
        Then the request is successful
        When I save "id"
        And I request the post "{id}"
        Then the request is successful
        And the response has the following attributes:
            | attribute | type    | value |
            | Title     | string  | foo   |
            | Body      | string  | bar   |
            | User Id   | numeric | 12    |
            | Id        | numeric | {id}  |
