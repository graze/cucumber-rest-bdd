Feature: Dealing with sub objects

    Background:
        Given I am a client

    Scenario: Create and read an item with child objects
        When I request to create a post with:
            | attribute   | type    | value |
            | Title       | string  | foo   |
            | Body        | string  | bar   |
            | User : Id   | numeric | 1     |
            | User : name | string  | name  |
        Then the request is successful and a post was created
        And the response has the following attributes:
            | attribute   | type    | value |
            | Title       | string  | foo   |
            | Body        | string  | bar   |
            | User : Id   | numeric | 1     |
            | User : name | string  | name  |

    Scenario: Request a single item with child objects
        When I request the comment "1" with:
            | `_expand` | post |
        Then the response has the following attributes:
            | attribute    | type   | value                                                                                                                                                                |
            | name         | string | id labore ex et quam laborum                                                                                                                                         |
            | email        | string | Eliseo@gardner.biz                                                                                                                                                   |
            | body         | string | laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium           |
            | post : title | string | sunt aut facere repellat provident occaecati excepturi optio reprehenderit                                                                                           |
            | post : body  | string | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |

    Scenario: Request an item within a list of items
        When I request a list of comments with:
            | `_expand` | post |
            | Post ID   | 1    |
        Then the response is a list of more than 1 item
        And the response is a list with at least one item with the following attributes:
            | attribute | type   | value                                                                                                                                                      |
            | name      | string | id labore ex et quam laborum                                                                                                                               |
            | email     | string | Eliseo@gardner.biz                                                                                                                                         |
            | body      | string | laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium |

    Scenario: Match an item with a list of items
        When I request the post "1" with:
            | `_embed` | comments |
        Then the response has the following attributes:
            | attribute | type   | value                                                                                                                                                                |
            | title     | string | sunt aut facere repellat provident occaecati excepturi optio reprehenderit                                                                                           |
            | body      | string | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |
        And the response has 1 comment with attributes:
            | attribute | type   | value                                                                                                                                                      |
            | name      | string | id labore ex et quam laborum                                                                                                                               |
            | email     | string | Eliseo@gardner.biz                                                                                                                                         |
            | body      | string | laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium |
        And the response has five comments with attributes:
            | attribute | type    | value |
            | Post Id   | integer | 1     |
        And the response has at least five comments

    Scenario: Match a list of items within a list of items
        When I request a list of posts with:
            | `_embed` | comments |
        Then the response is a list with at least one item with the following attributes:
            | attribute | type   | value                                                                                                                                                                |
            | title     | string | sunt aut facere repellat provident occaecati excepturi optio reprehenderit                                                                                           |
            | body      | string | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |
        And the response is a list with at least one item with 1 comment with attributes:
            | attribute | type   | value                                                                                                                                                      |
            | name      | string | id labore ex et quam laborum                                                                                                                               |
            | email     | string | Eliseo@gardner.biz                                                                                                                                         |
            | body      | string | laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium |
        And the response is a list with at least one item with 5 comments with attributes:
            | attribute | type    | value |
            | Post Id   | integer | 1     |
        And the response is a list with at least one item with at least five comments

    Scenario: Multiple levels
        When I request to create a post with:
            | attribute                     | type    | value           |
            | title                         | string  | test            |
            | body                          | string  | multiple        |
            | comments : [0] : common       | integer | 1               |
            | comments : [0] : id           | integer | 1               |
            | comments : [0] : title        | string  | fish            |
            | comments : [0] : body         | string  | cake            |
            | comments : [0] : image : href | string  | some_url        |
            | comments : [0] : image : name | string  | some name       |
            | comments : [1] : common       | integer | 1               |
            | comments : [1] : id           | integer | 2               |
            | comments : [1] : title        | string  | foo             |
            | comments : [1] : body         | string  | bar             |
            | comments : [1] : image : href | string  | some_url        |
            | comments : [1] : image : name | string  | some other name |
        Then the response has the attributes:
            | attribute | type   | value    |
            | title     | string | test     |
            | body      | string | multiple |
        And the response has a list of 2 comments
        And the response has two comments with attributes:
            | attribute | type    | value |
            | common    | integer | 1     |
        And the response has two comments have an image with the attributes:
            | attribute | type   | value    |
            | href      | string | some_url |
        And the response has one comments have an image with the attributes:
            | attribute | type   | value     |
            | name      | string | some name |
        And the response has one comments have an image with the attributes:
            | attribute | type   | value           |
            | name      | string | some other name |
        And the response has one comment with the attributes:
            | attribute | type    | value |
            | Id        | integer | 1     |
            | Title     | string  | fish  |
            | Body      | string  | cake  |
        And the response has one comment has the attributes:
            | attribute | type    | value |
            | Id        | integer | 2     |
            | Title     | string  | foo   |
            | Body      | string  | bar   |

    Scenario: Multiple levels in array
        When I request a list of posts with:
            | `_embed` | comments |
        Then the request is successful
        And the response is a list with one post with one comment with attributes:
            | attribute | type    | value |
            | Id        | integer | 1     |
        And the response is a list with at least ten posts with five comments
        And the response is a list with more than 95 posts with more than four comments
