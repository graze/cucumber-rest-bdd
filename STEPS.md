# Gherkin Steps

This test suite introduces behavioural test steps on top of functional REST API steps from [cucumber-api](https://github.com/hidroh/cucumber-api)

The following is a list of steps, and their equivalent functional step

## Setup

```
[Behavioural] Given I am a client
[Functional] Given I send and accept JSON
```

## Retrieval

```
[Behavioural] When I request an item "2"
[Functional] When I send a GET request to "http://url/items/2"

[Behavioural] When I request a list of items
[Functional] When I send a GET request to "http://url/items"

[Behavioural]
When I request a list of items with:
    | User Id | 12 |
[Functional]
When I send a GET request to "http://url/items" with:
    | userId |
    | 12     |
```

## Creation

```
[Behavioural] When I request to create an item
[Functional] When I send a POST request to "http://url/items"

[Behavioural]
When I request to create an item with:
    | attribute | type    | value |
    | User Id   | integer | 12    |
    | Title     | string  | foo   |
[Functional]
When I set JSON request body to:
    """
    {"userId":12,"title":"foo"}
    """
And I send a POST request to "http://url/items"

[Behavioural] When I request to create an item with id "4"
[Functional] When I send a PUT request to "http://url/items/4"

[Behavioural]
When I request to replace the item "4" with:
    | attribute | type    | value |
    | User Id   | integer | 7     |
    | Title     | string  | foo   |
[Functional]
When I set JSON request body to:
    """
    {"userId":7,"title":"foo"}
    """
And I send a PUT request to "http://url/items/4"
```

## Modification

```
[Behavioural]
When I request to modify the item "4" with:
    | attribute | type    | value |
    | Body      | string  | bar   |
[Functional]
When I set JSON request body to:
    """
    {"body":"bar"}
    """
And I send a PATCH request to "http://url/items/4"
```

## Status Inspection
```
[Behavioural] Then the request is successful
[Functional] Then the response status should be "200"

[Behavioural] Then the request was redirected
[Functional] <N/A> (response status between "300" and "400")

[Behavioural] Then the request failed
[Functional] <N/A> (response status between "400" and "600")

[Behavioural] Then the request was successful and an item was created
[Functional] Then the response status should be "201"

[Behavioural] Then the request was successfully accepted
[Functional] Then the response status should be "202"

[Behavioural] Then the request was successful and no response body is returned
[Functional] Then the response status should be "204"

[Behavioural] Then the request failed because it was invalid
[Functional] Then the response status should be "400"

[Behavioural] Then the request failed because i am unauthorised
[Functional] Then the response status should be "401"

[Behavioural] Then the request failed because it was forbidden
[Functional] Then the response status should be "403"

[Behavioural] Then the request failed because the item was not found
[Functional] Then the response status should be "404"

[Behavioural] Then the request failed because it was not allowed
[Functional] Then the response status should be "405"

[Behavioural] Then the request failed because there was a conflict
[Functional] Then the response status should be "409"

[Behavioural] Then the request failed because the item has gone
[Functional] Then the response status should be "410"

[Behavioural] Then the request failed because it was not implemented
[Functional] Then the response status should be "501"
```

## Response interrogation

```
[Behavioural]
Then the response has the following attributes:
    | attribute | type    | value |
    | User Id   | integer | 12    |
    | Title     | string  | foo   |
    | Body      | string  | bar   |
[Functional]
Then the JSON response should have "userId" of type numeric with value "12"
Then the JSON response should have "title" of type numeric with value "foo"
Then the JSON response should have "body" of type numeric with value "bar"

[Behavioural] Then the response is a list of 12 items
[Functional] Then the JSON response should have "$." of type array with 12 entries

[Behavioural] Then the response is a list of at least 12 items
[Functional] <N/A>

[Behavioural] Then two items have have the following attributes:
    | attribute | type    | value |
    | User Id   | integer | 12    |
    | Title     | string  | foo   |
    | Body      | string  | bar   |
[Functional] <N/A>

[Behavioural] <N/A>
[Functional] Then the JSON response should follow "schema.json"
```

## Value retrieval from response

```
[Behavioural]
When I save "User Id" as "user"
And I request the user "{user}"
[Functional]
When I grab "$.userId" as "user"
And I send a GET request to "http://url/users/{user}"
```
