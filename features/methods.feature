Feature: Performing different rest methods

    Background:
        Given I am a client

    Scenario: Retrieve a single item
        When I request the post "1"
        Then the request was successful
        And the response has the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 1     |
            | Id        | numeric | 1     |
            | Title     | string  | sunt aut facere repellat provident occaecati excepturi optio reprehenderit |
            | Body      | string  | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |

    Scenario: Retrieve multiple items
        When I request a list of posts
        Then the request was successful
        And the response is a list of at least 2 posts
        And one post has the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 1     |
            | Id        | numeric | 1     |
            | Title     | string  | sunt aut facere repellat provident occaecati excepturi optio reprehenderit |
            | Body      | string  | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |
        And one post has the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 1     |
            | Id        | numeric | 2     |
            | Title     | string  | qui est esse |
            | Body      | string  | est rerum tempore vitae\\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\\nqui aperiam non debitis possimus qui neque nisi nulla |
        And ten posts have the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 5     |

    Scenario: Retrieve multiple items with filter
        When I request a list of posts with:
            | User Id | 2 |
        Then the request is successful
        And the response is a list of at least 2 posts
        And one post has the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 2     |
            | Id        | numeric | 11    |
            | Title     | string  | et ea vero quia laudantium autem |
            | Body      | string  | delectus reiciendis molestiae occaecati non minima eveniet qui voluptatibus\\naccusamus in eum beatae sit\\nvel qui neque voluptates ut commodi qui incidunt\nut animi commodi |
        And one post has the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 2     |
            | Id        | numeric | 12    |
            | Title     | string  | in quibusdam tempore odit est dolorem |
            | Body      | string  | itaque id aut magnam\\npraesentium quia et ea odit et ea voluptas et\\nsapiente quia nihil amet occaecati quia id voluptatem\\nincidunt ea est distinctio odio |

    Scenario: Create an item
        When I request to create a post with:
            | attribute | type    | value |
            | Title     | string  | foo   |
            | Body      | string  | bar   |
            | User Id   | numeric | 1     |
        Then the request is successful and a post was created
        And the response has the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 1     |
            | Title     | string  | foo   |
            | Body      | string  | bar   |

    Scenario: Remove an item
        When I request to remove the post "20"
        Then the request is successful

    Scenario: Modify an item
        When I request to modify the post "21" with:
            | attribute | type    | value |
            | Title     | string  | foo   |
        Then the request is successful
        And the response has the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 3     |
            | Title     | string  | foo   |
            | Body      | string  | repellat aliquid praesentium dolorem quo\\nsed totam minus non itaque\\nnihil labore molestiae sunt dolor eveniet hic recusandae veniam\\ntempora et tenetur expedita sunt |

    Scenario: Update an item with Id
        When I request to create a post "22" with:
            | attribute | type    | value |
            | Title     | string  | foo   |
            | Body      | string  | bar   |
            | User Id   | numeric | 1     |
        Then the request is successful
        And the response has the following attributes:
            | attribute | type    | value |
            | User Id   | numeric | 1     |
            | Id        | numeric | 22    |
            | Title     | string  | foo   |
            | Body      | string  | bar   |
