require 'cucumber-api/response'
require 'cucumber-api/steps'

ParameterType(
  name: 'item_type',
  regexp: /([\w\s]+)/,
  transformer: ->(s) { s },
  use_for_snippets: false
)

Then('the request is/was successful') do
  if @response.code < 200 || @response.code >= 300
    raise %(Expected Successful response code 2xx but was #{@response.code})
  end
end

Then('the request is/was redirected') do
  if @response.code < 300 || @response.code >= 400
    raise %(Expected redirected response code 3xx but was #{@response.code})
  end
end

Then('the request fail(s/ed)') do
  if @response.code < 400 || @response.code >= 600
    raise %(Expected failed response code 4xx\/5xx but was #{@response.code})
  end
end

Then('the request is/was successful and a/the resource is/was created') do
  steps %(Then the response status should be "201")
end

Then('(the request is/was successful and )a/the {item_type} is/was created') do |_item_type|
  steps %(Then the response status should be "201")
end

Then('the request is/was successfully accepted') do
  steps %(Then the response status should be "202")
end

Then('the request is/was successful and (an )empty/blank/no response body is/was returned') do
  steps %(Then the response status should be "204")
  raise %(Expected the request body to be empty) unless @response.body.empty?
end

Then('the request fail(s/ed) because (the )it/resource is/was invalid') do
  steps %(Then the response status should be "400")
end

Then('the request fail(s/ed) because (the ){item_type} is/was invalid') do |_item_type|
  steps %(Then the response status should be "400")
end

Then('the request fail(s/ed) because (the )it/resource is/was/am/are unauthorised/unauthorized') do
  steps %(Then the response status should be "401")
end

Then('the request fail(s/ed) because (the ){item_type} is/was/am/are unauthorised/unauthorized') do |_item_type|
  steps %(Then the response status should be "401")
end

Then('the request fail(s/ed) because (the )it/resource is/was forbidden') do
  steps %(Then the response status should be "403")
end

Then('the request fail(s/ed) because (the ){item_type} is/was forbidden') do |_item_type|
  steps %(Then the response status should be "403")
end

Then('the request fail(s/ed) because (the )it/resource is/was not found') do
  steps %(Then the response status should be "404")
end

Then('the request fail(s/ed) because (the ){item_type} is/was not found') do |_item_type|
  steps %(Then the response status should be "404")
end

Then('the request fail(s/ed) because (the )it/resource is/was not allowed') do
  steps %(Then the response status should be "405")
end

Then('the request fail(s/ed) because (the ){item_type} is/was not allowed') do |_item_type|
  steps %(Then the response status should be "405")
end

Then('the request fail(s/ed) because there is/was/has a conflict') do
  steps %(Then the response status should be "409")
end

Then('the request fail(s/ed) because there is/was/has a conflict with {item_type}') do |_item_type|
  steps %(Then the response status should be "409")
end

Then('the request fail(s/ed) because (the )it/resource is/was/has gone') do
  steps %(Then the response status should be "410")
end

Then('the request fail(s/ed) because (the ){item_type} is/was/has gone') do |_item_type|
  steps %(Then the response status should be "410")
end

Then('the request fail(s/ed) because (the )it/resource is/was not implemented') do
  steps %(Then the response status should be "501")
end

Then('the request fail(s/ed) because (the ){item_type} is/was not implemented') do |_item_type|
  steps %(Then the response status should be "501")
end
