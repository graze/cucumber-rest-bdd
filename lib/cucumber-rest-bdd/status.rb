require 'cucumber-api/response'
require 'cucumber-api/steps'

Then(/^the request (?:is|was) successful$/) do
    steps %Q{Then the response status should be "200"}
end

Then(/^the request (?:is|was) successful and (?:a resource|.+) (?:is|was) created$/) do
    steps %Q{Then the response status should be "201"}
end

Then(/^the request (?:is|was) successfully accepted$/) do
  steps %Q{Then the response status should be "202"}
end

Then(/^the request (?:is|was) successful and (?:no|an empty) response body is returned$/) do
  steps %Q{Then the response status should be "204"}
  raise %/Expected the request body to be empty/ if !@response.body.empty?
end

Then(/^(?:it|the request) fail(?:s|ed) because it (?:is|was) invalid$/) do
    steps %Q{Then the response status should be "400"}
end

Then(/^(?:it|the request) fail(?:s|ed) because (?:.+) (?:is|was|am|are) unauthori[sz]ed$/) do
    steps %Q{Then the response status should be "401"}
end

Then(/^(?:it|the request) fail(?:s|ed) because (?:.+) (?:is|was) forbidden$/) do
    steps %Q{Then the response status should be "403"}
end

Then(/^(?:it|the request) fail(?:s|ed) because the (?:.+) (?:is|was) not found$/) do
    steps %Q{Then the response status should be "404"}
end

Then(/^(?:it|the request) fail(?:s|ed) because it (?:is|was) not allowed$/) do
    steps %Q{Then the response status should be "405"}
end

Then(/^(?:it|the request) fail(?:s|ed) because there (?:is|was|has) a conflict(?: with .+)?$/) do
    steps %Q{Then the response status should be "409"}
end

Then(/^(?:it|the request) fail(?:s|ed) because the (?:.+) (?:is|was|has) gone$/) do
    steps %Q{Then the response status should be "410"}
end

Then(/^(?:it|the request) fail(?:s|ed) because the (?:.+) (?:is|was) not implemented$/) do
    steps %Q{Then the response status should be "501"}
end
