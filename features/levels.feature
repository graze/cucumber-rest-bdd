Feature: Request multiple levels of REST api
    As a user
    I would like to query a url with multiple levels of depth
    So that I can get all the data from this api

    Background:
        Given I am a client

    Scenario: get single id from sub layer
        When I request the comment "1" for post "1"
        Then the request was successful
        And the response has the attributes:
            | attribute | type   | value |
            | id        | int    | 1     |

    Scenario: get list from sub layer
        When I request a list of comments for post "1"
        Then the request was successful
        And the response is a list of more than 4 comments
        And one comment has the attributes:
            | attribute | type   | value |
            | id        | int    | 1     |

    Scenario: multiple sub levels
        When I request the photo "1" for album "1" for user "1"
        Then the request was successful
        And the response has the attributes:
            | attribute | type   | value                                              |
            | title     | string | accusamus beatae ad facilis cum similique qui sunt |

    Scenario: request a list of multiple sub levels
        When I request a list of photos for album "1" for user "1"
        Then the request was successful
        And the response is a list of more than 2 photos
        And one photo has the attributes:
            | attribute | type   | value                                              |
            | title     | string | accusamus beatae ad facilis cum similique qui sunt |

    Scenario: create a item as a child
        When I request to create a comment for post "18" with:
            | attribute | type   | value |
            | Title     | string | foo   |
            | Body      | string | bar   |
        Then the comment was created
        And the response has the attributes:
            | attribute | type   | value |
            | Post Id   | string | 18    |
            | Title     | string | foo   |
            | Body      | string | bar   |
        When I request a list of comments for post "18"
        Then the request was successful
        And one comment has the attributes:
            | attribute | type   | value |
            | Title     | string | foo   |
            | Body      | string | bar   |

    Scenario: create a 2nd level child item
        When I request to create a photo in album "2" for user "1" with:
            | attribute | type   | value |
            | title     | string | foo   |
        Then the comment was created
        And the response has the attributes:
            | attribute | type   | value |
            | Album Id  | int    | 2     |
            | Title     | string | foo   |
        When I request a list of photos for album "2" for user "1"
        Then the request was successful
        And one comment has the attributes:
            | attribute | type   | value |
            | Title     | string | foo   |

    Scenario: delete a child item
        When I request to delete the comment "91" for post "19"
        Then the request was successful
        When I request a list of comments for post "19"
        Then the request was successful
        And zero comments have the attributes:
            | attribute | type | value |
            | id        | int  | 91    |

    Scenario: modify a child item
        When I request to modify the comment "102" for post "21" with:
            | attribute | type   | value |
            | Name      | string | foo   |
            | Body      | string | bar   |
        Then the request was successful
        And the response has the attributes:
            | attribute | type   | value |
            | Post Id   | int    | 21    |
            | Name      | string | foo   |
            | Body      | string | bar   |
        When I request a list of comments for post "21"
        Then the request was successful
        And one comment has the attributes:
            | attribute | type   | value |
            | Name      | string | foo   |
            | Body      | string | bar   |

    Scenario: modify a child item
        When I request to replace the comment "106" for post "22" with:
            | attribute | type   | value |
            | Title     | string | foo   |
            | Body      | string | bar   |
        Then the request was successful
        And the response has the attributes:
            | attribute | type   | value |
            | Post Id   | int    | 22    |
            | Title     | string | foo   |
            | Body      | string | bar   |
        When I request a list of comments for post "22"
        Then the request was successful
        And one comment has the attributes:
            | attribute | type   | value |
            | Title     | string | foo   |
            | Body      | string | bar   |
        When I request the comment "106"
        Then the request was successful
        And the response has the attributes:
            | attribute | type   | value |
            | Title     | string | foo   |
            | Body      | string | bar   |
