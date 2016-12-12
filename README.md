# Cucumber Rest BDD

A set of Behavioural tests that can be run against a REST API.

This is based from: http://gregbee.ch/blog/effective-api-testing-with-cucumber

A list of [Steps](STEPS.md) shows the comparison between Behavioural and Functional tests provided by this package.

## Configuration

The following environment variables modify how this will operate:

- `endpoint` - (string) the base url to call for each request
- `data_key` - (string) the root data key (if applicable) (for example: `"data"` if all responses have a `{"data":{}}` field)
- `field_separator` - (string) the separator used between words by the api
- `field_camel` - (bool [`true`|`false`]) does this endpoint use camelCase for fields (default: `false`)
- `resource_single` - (bool [`true`|`false`]) if each resource should be singularized or not (default: `false`)

## Examples

- For a full list of steps see: [STEPS](STEPS.md)
- These examples are taken from the test [features](features)

### Retrieve items

```gherkin
Given I am a client
When I request the post "1"
Then the request was successful
And the response has the following attributes:
    | attribute | type    | value |
    | User Id   | numeric | 1     |
    | Id        | numeric | 1     |
    | Title     | string  | sunt aut facere repellat provident occaecati excepturi optio reprehenderit |
    | Body      | string  | quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto |
```

```gherkin
Given I am a client
When I request a list of posts with:
    | User Id | 2 |
Then the request is successful
And the response is a list of at least 2 posts
And one response has the following attributes:
    | attribute | type    | value |
    | User Id   | numeric | 2     |
    | Id        | numeric | 11    |
    | Title     | string  | et ea vero quia laudantium autem |
    | Body      | string  | delectus reiciendis molestiae occaecati non minima eveniet qui voluptatibus\\naccusamus in eum beatae sit\\nvel qui neque voluptates ut commodi qui incidunt\nut animi commodi |
```

### Creation

```gherkin
Given I am a client
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
```

### Removal

```gherkin
Given I am a client
When I request to remove the post "20"
Then the request is successful
```

### Modification

```gherkin
Given I am a client
When I request to modify the post "21" with:
    | attribute | type    | value |
    | Title     | string  | foo   |
Then the request is successful
And the response has the following attributes:
    | attribute | type    | value |
    | User Id   | numeric | 3     |
    | Title     | string  | foo   |
    | Body      | string  | repellat aliquid praesentium dolorem quo\\nsed totam minus non itaque\\nnihil labore molestiae sunt dolor eveniet hic recusandae veniam\\ntempora et tenetur expedita sunt |
```

### Multiple Requests

```gherkin
Given I am a client
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
```

## Resources

A resource "name" is attempted to be retrieved from the given name of the item to be retrieved. This pluralises, ensures everything is lower case, removes any unparameterisable characters and uses a `-` separator.

```
Token -> tokens
User -> users
Big Life -> big-lifes
octopus -> octopi
```

If the environment variable: `resource_single` is set to `true` then it will not attempt to pluralise the resources.

```
Token -> token
User -> user
```

## Attributes

### Types

Attribute types:
The following types are supported:

| type    | common name | example   |
|---------|-------------|-----------|
| numeric | integer     | 12        |
| integer | integer     | 05        |
| string  | string      | "text"    |
| array   | array       | ["a"]     |
| object  | object      | {"a":"b"} |

### Name conversion

attributes are converted into singular parametrised versions of the provided name:

The conversion is based on the provided environment variables `field_camel` and `field_separator`

**Default**
```
field_camel=false
field_separator=_

Someid -> someid
Product Id -> product_id
Bodies -> body
```

**CamelCase**
```
field_camel=true
field_separator=_

Someid -> someid
Product Id -> productId
Bodies -> body
```

**Other separator**
```
field_camel=false
field_separator=-

Someid -> someid
Product Id -> product-id
Bodies -> body
```
