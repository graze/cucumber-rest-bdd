Feature: Dealing with sub objects

    Background:
        Given I am a client

    Scenario: Handle null values
        When I request to create a post with:
            | attribute | type   | value |
            | title     | string | foo   |
            | body      | string | bar   |
            | extra     | null   |       |
        Then the request was successful
        And the response has the following attributes:
            | attribute | type   | value |
            | title     | string | foo   |
            | body      | string | bar   |
            | extra     | nil    |       |

    Scenario: Handle types
        When I request to create a post with:
            | attribute | type     | value               |
            | title     | string   | foo                 |
            | body      | text     | bar                 |
            | int       | int      | 1                   |
            | long      | long     | 1347289473247823749 |
            | float     | float    | 1.2                 |
            | double    | double   | 1.4                 |
            | number    | number   | 12                  |
            | numeric   | numeric  | 15                  |
            | bool      | bool     | true                |
            | boolean   | boolean  | false               |
            | null      | null     |                     |
            | nil       | nil      |                     |
        Then the request was successful
        And the response has the following attributes:
            | attribute | type     | value               |
            | title     | string   | foo                 |
            | body      | text     | bar                 |
            | int       | int      | 1                   |
            | long      | long     | 1347289473247824000 |
            | float     | float    | 1.2                 |
            | double    | double   | 1.4                 |
            | number    | number   | 12                  |
            | numeric   | numeric  | 15                  |
            | bool      | bool     | true                |
            | boolean   | boolean  | false               |
            | null      | null     |                     |
            | nil       | nil      |                     |
