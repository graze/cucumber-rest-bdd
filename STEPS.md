# Gherkin Steps

This test suite introduces behavioural test steps on top of functional REST API steps from [cucumber-api](https://github.com/hidroh/cucumber-api)

The following is a list of steps, and their equivalent functional step

## Setup

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Given I am a client                                 Given I send and accept JSON
```

## Retrieval

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I request an item "2"                          When I send a GET request to "http://url/items/2"

When I request a list of items                      When I send a GET request to "http://url/items"

When I request a list of items with:                When I send a GET request to "http://url/items" with:
   | User Id | 12 |                                     | userId |
                                                        | 12     |
```

## Creation

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I request to create an item                    When I send a POST request to "http://url/items"

When I request to create an item with:              When I set JSON request body to:
    | attribute | type    | value |                     """
    | User Id   | integer | 12    |                     {"userId":12,"title":"foo"}
    | Title     | string  | foo   |                     """
                                                    And I send a POST request to "http://url/items"

When I request to create an item with id "4"        When I send a PUT request to "http://url/items/4"

When I request to replace the item "4" with:        When I set JSON request body to:
    | attribute | type    | value |                     """
    | User Id   | integer | 7     |                     {"userId":7,"title":"foo"}
    | Title     | string  | foo   |                     """
                                                    And I send a PUT request to "http://url/items/4"
```

## Modification

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I request to modify the item "4" with:         When I set JSON request body to:
    | attribute | type    | value |                     """
    | Body      | string  | bar   |                     {"body":"bar"}
                                                        """
                                                    And I send a PATCH request to "http://url/items/4"
```

## Status Inspection

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Then the request is successful                      Then the response status should be "200"

Then the request was redirected                     <N/A> (response status between "300" and "400")

Then the request failed                             <N/A> (response status between "400" and "600")

Then the request was successful and an item was     Then the response status should be "201"
  created

Then the request was successfully accepted          Then the response status should be "202"

Then the request was successful and no response     Then the response status should be "204"
  body is returned

Then the request failed because it was invalid      Then the response status should be "400"

Then the request failed because I am unauthorised   Then the response status should be "401"

Then the request failed because it was forbidden    Then the response status should be "403"

Then the request failed because the item was not    Then the response status should be "404"
  found

Then the request failed because it was not allowed  Then the response status should be "405"

Then the request failed because there was a         Then the response status should be "409"
  conflict

Then the request failed because the item has gone   Then the response status should be "410"

Then the request failed because it was not          Then the response status should be "501"
  implemented
```

## Response Inspection

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Then the response has the following attributes:     Then the JSON response should have "userId" of type numeric
    | attribute | type    | value |                   with value "12"
    | User Id   | integer | 12    |                 Then the JSON response should have "title" of type numeric
    | Title     | string  | foo   |                   with value "foo"
    | Body      | string  | bar   |                 Then the JSON response should have "body" of type numeric with
                                                      value "bar"

Then the response is a list of 12 items             Then the JSON response should have "$." of type array with 12
                                                      entries

Then the response is a list of at least 12 items    Then the JSON response should have "$." of type array with at
                                                      least 12 entries
Then the response is a list of at most 12 items     <N/A>
Then the response is a list of fewer than 12 items  <N/A>
Then the response is a list of more than 12 items   <N/A>

Then two items have have the following attributes:  <N/A>
    | attribute | type    | value |
    | User Id   | integer | 12    |
    | Title     | string  | foo   |
    | Body      | string  | bar   |

Then more than two items have have the following    <N/A>
  attributes:
    | attribute | type    | value |
    | User Id   | integer | 12    |
    | Title     | string  | foo   |
    | Body      | string  | bar   |

<N/A>                                               Then the JSON response should follow "schema.json"

<N/A>                                               Then the response has the header "Content Type" with value
                                                      "application/json"
```

### Error Handling

Using the environment variable: `error_key` to represent the error resource

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Then the response has one error:                    Then the JSON response should have "errors[0].code" of type
    | attribute | type   | value   |                  string with value "ERR-BLA"
    | code      | string | ERR-BLA |

Then the response has one error with attributes:    Then the JSON response should have "errors[0].code" of type
    | attribute | type   | value   |                  string with value "ERR-BLA"
    | code      | string | ERR-BLA |

Then the response has at least one error           Then the JSON response should have "errors" of type array
                                                     with at least 1 entry

Then the response has an error                      Then the JSON response should have required key "error" of
Then the response contains an error                   type object

Then the response has two errors with:
    | attribute | type   | value       |
    | message   | string | super error |

Then the response has three errors with two links   <N/A>
  with:
    | attribute | type   | value       |
    | href      | string | http://oops |
```

### Attribute saving and re-use

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I save "User Id" as "user"                     When I grab "$.userId" as "user"
And I request the user "{user}"                     And I send a GET request to "http://url/users/{user}"
```

### Nested requests

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
When I request a list of comments for post "1"      When I send a GET request to "http://url/posts/1/comments"

When I request the comment "2" for post "3"         When I send a GET request to "http://url/posts/3/comments/2"

When I request the photo "3" in album "4" for user  When I send a GET request to
  "5"                                                 "http://url/users/5/albums/4/photos/3"

When I request a list of photos in album "6" for    When I send a GET request to
  user "7"                                            "http://url/users/7/albums/6/photos"

When I request to create a comment for post "8"     When I send a POST request to "http://url/posts/8/comments"

When I request to modify the comment "9" for post   When I send a PATCH request to
  "10"                                                "http://url/posts/10/comments/9"

When I request to set photo "11" in album "12" to:  When I set JSON request body to:
    | attribute | type   | value                |       """
    | url       | string | http://url/image.jpg |       {"url":"http://url/image.jpg"}
                                                        """
                                                    And I send a PUT request to "http://url/albums/12/photos/11"
```

### Nested responses

```text
Behavioural                                         Functional
--------------------------------------------------- --------------------------------------------------------------
Then the response has the following attributes:     Then the JSON response should have "userId" of type numeric
    | attribute    | type    | value |                with value "12"
    | User Id      | integer | 12    |              Then the JSON response should have "title" of type numeric
    | Title        | string  | foo   |                with value "foo"
    | Body         | string  | bar   |              Then the JSON response should have "body" of type numeric with
    | Post : Title | string  | baz   |                value "bar"
    | Post : Body  | string  | boo   |              Then the JSON response should have "post.title" of type string
                                                      with value "baz"
                                                    Then the JSON response should have "post.body" of type string
                                                      with value "boo"

Then the response has a list of comments            Then the JSON response should have "comments" of type array

Then the response has a list of 2 comments          Then the JSON response should have "comments" of type array with
                                                      2 entries
Then the response has a list of at least            Then the JSON response should have "comments" of type array with
  2 comments                                          at least 2 entries

Then the response has a post with two comments      <N/A>
  with attributes:
    | attribute | type   | value |
    | Title     | string | foo   |
    | Body      | string | bar   |

Then two items contains two posts with three        <N/A>
  comments with an image with attributes:
    | attribute | type   | value    |
    | Href      | string | some_url |

Then more than two items contains fewer than two    <N/A>
  posts with at least three comments with an
  image with attributes:
    | attribute | type   | value    |
    | Href      | string | some_url |

Then the response has a post with a list of         Then the JSON response should have "post.comments" of type array
  comments

Then the response has a post with a list of more    Then the JSON response should have "post.comments" of type array
  than 3 comments                                     with at least 4 comments

Then more than three posts have less than two       <N/A>
  comments
```
