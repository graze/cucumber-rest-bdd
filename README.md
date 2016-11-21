# Cucumber Rest BDD

A set of Behavioural tests that can be run against a REST API.

This is based from: http://gregbee.ch/blog/effective-api-testing-with-cucumber

## Configuration

The following environment variables modify how this will operate:

- `endpoint` - (string) the base url to call for each request
- `root_key` - (string) the root data key (if applicable) (for example: `"data"` if all responses have a `{"data":{}}` field)
- `field_separator` - (string) the separator used between words by the api
- `field_camel` - (bool [`true`|`false`]) does this endpoint use camelCase for fields
- `resource_single` - (bool [`true`|`false`]) if each resource should be singularized or not (default is not)

## Resource Handling

## GET
```gherkin
When I request (?:a|the) (.+?)(?: with (?:key|id))? "([^"]*)"
When I request a list of ([^:]+)
When I request a list of (.+) with:
    | param 1 | value 1 |
    | param 2 | value 2 |

When I request a thing with key "bla"
  -> GET http://url/thing/bla
When I request the Token "e88f75e25307fa26ca699cb5c31bfb9f"
  -> GET http://url/tokens/e88f75e25307fa26ca699cb5c31bfb9f
When I request a Send Soon "435623"
  -> GET http://url/send-soons/435623
When I request a list of tokens
  -> GET http://url/tokens
When I request a list of tokens with:
    | apid | 1     |
    | type | login |
  -> GET http://url/tokens?apid=1&type=login
```

## DELETE
```gherkin
When I request to (?:delete|remove) the (.+) "([^"]*)"

When I request to delete the token "e88f75e25307fa26ca699cb5c31bfb9f"
  -> DELETE http://url/tokens/e88f75e25307fa26ca699cb5c31bfb9f
When I request to remove the item "7487584353"
  -> DELETE http://url/items/7487584353
```

## POST
```gherkin
When I request to create a ([^:]+?)
When I request to create a (.+?) with:
    | attribute | type    | value   |
    | param 1   | string  | value 1 |
    | param 2   | numeric | 2       |

When I request to create a token
  -> POST http://url/tokens
When I request to create a token with:
    | attribute | type    | value |
    | apid      | numeric | 1     |
    | type      | string  | login |
  -> POST http://url/tokens
  -> {"apid":1, "type": "login"}
```

## Status Checking
```gherkin
Then the request (?:is|was) successful
Then the request (?:is|was) successful and (?:a resource|.+) (?:is|was) created
Then the request (?:is|was) successfully accepted
Then the request (?:is|was) successful and (?:no|an empty) response body is returned
Then (?:it|the request) fail(?:s|ed) because it (?:is|was) invalid
Then (?:it|the request) fail(?:s|ed) because (?:.+) (?:is|was|am|are) unauthori[sz]ed
Then (?:it|the request) fail(?:s|ed) because (?:.+) (?:is|was) forbidden
Then (?:it|the request) fail(?:s|ed) because the (?:.+) (?:is|was) not found
Then (?:it|the request) fail(?:s|ed) because it (?:is|was) not allowed
Then (?:it|the request) fail(?:s|ed) because there (?:is|was) a conflict(?: with .+)?
Then (?:it|the request) fail(?:s|ed) because the (?:.+) (?:is|was|has) gone
Then (?:it|the request) fail(?:s|ed) because the (?:.+) (?:is|was) not implemented

Then the request is successful [200]
Then the request was successful and a token was created [201]
Then the request was successfully accepted [202]
Then the request was successful and no body was returned [204]
Then the request fails because it was invalid [400]
Then the request fails because we are unauthorised [401]
Then the request fails because it was forbidden [403]
Then the request fails because it was not found [404]
Then the request fails because it was not allowed [405]
Then the request fails because there was a conflict [409]
Then the request fails because the token was gone [410]
Then the request fails because it was not implemented [501]
```

## Response handling

The use of the environment variable: `root_key` will change the operation of this collection:

**Not Set**
```
{"field":"value","field2":"value2"}
[{"field":"value"},{"field":"value2"}]
```

**Set**
```
root_key=data
{"data":{"field":"value","field2":"value2"}}
{"data":[{"field":"value"},{"field":"value2"}]}
```

```gherkin
Then the response has the following attributes:
    | attribute | type   | value                            |
    | Token     | String | e88f75e25307fa26ca699cb5c31bfb9f |
    | Apid      | String | 1                                |
-> response = {"data":{"apid":"1","token":"e88f75e25307fa26ca699cb5c31bfb9f",...}}

Then the response is a list containing two tokens
-> response = {"data":[{<token>},{<token>}]}

Then one token has the following attributes:
    | attribute | type   | value                            |
    | Token     | String | e88f75e25307fa26ca699cb5c31bfb9f |
    | Apid      | String | 1                                |
-> response = {"data":[{"apid":"1","token":"e88f75e25307fa26ca699cb5c31bfb9f",...}]}
```

### Attributes

attributes are converted into singular parametrised versions of the provided name:

The conversion is based on the provided environment variables `field_camel` and `field_separator`

**Default**
```
field_camel=false
field_separator=_
Apid -> apid
Product Id -> product_id
Bodies -> body
```

**CamelCase**
```
field_camel=true
field_separator=_
Apid -> apid
Product Id -> productId
Bodies -> body
```

**Other separator**
```
field_camel=false
field_separator=-
Apid -> apid
Product Id -> product-id
Bodies -> body
```
