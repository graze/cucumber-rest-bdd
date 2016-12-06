Feature: We can inspect the headers of the response

    Scenario: Parse a single result
        When I request the post "1"
        Then the request was successful
        And the response has the header "Content Type" with value "application/json; charset=utf-8"

    Scenario Outline: Can check for multiple headers
        When I request the post "1"
        Then the request was successful
        And the response has the header "<header>" with the value "<value>"

        Examples:
            | header        | value                           |
            | Content Type  | application/json; charset=utf-8 |
            | Cache Control | no-cache                        |
