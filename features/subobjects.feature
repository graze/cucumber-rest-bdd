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
            | attribute    | type   | value |
            | name         | string | id labore ex et quam laborum |
            | email        | string | Eliseo@gardner.biz |
            | body         | string | laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium |
            | post : title | string | sunt aut facere repellat provident occaecati excepturi optio reprehenderit |
            | post : body  | string | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |

    Scenario: Request an item within a list of items
        When I request a list of comments with:
            | `_expand` | post |
            | Post ID   | 1    |
        Then the response is a list of more than 1 comment
        And one comment has the following attributes:
            | attribute    | type   | value |
            | name         | string | id labore ex et quam laborum |
            | email        | string | Eliseo@gardner.biz |
            | body         | string | laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium |
            | post : title | string | sunt aut facere repellat provident occaecati excepturi optio reprehenderit |
            | post : body  | string | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |

#    Scenario: Match an item with a list of items
#        When I request the posts "1" with:
#            | `_embed` | comments |
#        Then the response has the following attributes:
#            | attribute         | type   | value |
#            | title             | string | sunt aut facere repellat provident occaecati excepturi optio reprehenderit |
#            | body              | string | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |
#            | comment #1: name  | string | id labore ex et quam laborum |
#            | comment #1: email | string | Eliseo@gardner.biz |
#            | comment #1: body  | string | laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium |
