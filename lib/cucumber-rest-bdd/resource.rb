require 'cucumber-api/response'
require 'cucumber-api/steps'
require 'active_support/inflector'
require 'cucumber-rest-bdd/url'
require 'cucumber-rest-bdd/types'
require 'cucumber-rest-bdd/hash'
require 'easy_diff'

Given(/^I am a client$/) do
    steps %Q{
      Given I send "application/json" and accept JSON
    }
end

# GET

When(/^I request (?:an?|the) (.+?)(?: with (?:key|id))? "([^"]*)"$/) do |resource, token|
    resource_name = get_resource(resource)
    url = get_url("#{resource_name}/#{token}")
    steps %Q{When I send a GET request to "#{url}"}
end

When(/^I request (?:an?|the) (.+?)(?: with (?:key|id))? "([^"]*)" with:$/) do |resource, token, params|
    resource_name = get_resource(resource)
    url = get_url("#{resource_name}/#{token}")
    unless params.raw.empty?
        query = params.raw.map{|key, value| %/#{get_parameter(key)}=#{resolve(value)}/}.join("&")
        url = "#{url}?#{query}"
    end
    steps %Q{When I send a GET request to "#{url}"}
end

When(/^I request a list of ([^:]+)$/) do |resource|
    resource_name = get_resource(resource)
    url = get_url("#{resource_name}")
    steps %Q{When I send a GET request to "#{url}"}
end

When(/^I request a list of (.+) with:$/) do |resource, params|
    resource_name = get_resource(resource)
    url = get_url("#{resource_name}")
    unless params.raw.empty?
        query = params.raw.map{|key, value| %/#{get_parameter(key)}=#{resolve(value)}/}.join("&")
        url = "#{url}?#{query}"
    end
    steps %Q{When I send a GET request to "#{url}"}
end

# DELETE

When(/^I request to (?:delete|remove) the (.+) "([^"]*)"$/) do |resource, token|
    resource_name = get_resource(resource)
    url = get_url("#{resource_name}/#{token}")
    steps %Q{When I send a DELETE request to "#{url}"}
end

# POST

When(/^I request to create an? ([^:]+?)$/) do |resource|
    resource_name = get_resource(resource)
    url = get_url("#{resource_name}")
    steps %Q{When I send a POST request to "#{url}"}
end

When(/^I request to create an? ([^"]+?) with:$/) do |resource, params|
    resource_name = get_resource(resource)
    request_hash = get_attributes(params.hashes)
    json = MultiJson.dump(request_hash)
    url = get_url("#{resource_name}")
    steps %Q{
        When I set JSON request body to:
            """
            #{json}
            """
        And I send a POST request to "#{url}"
    }
end

# PUT

When(/^I request to (?:create|replace) (?:an?|the) ([^"]+?)(?: with (?:key|id))? "([^"]+)"$/) do |resource, id|
    resource_name = get_resource(resource)
    url = get_url("#{resource_name}/#{id}")
    steps %Q{
        When I send a PUT request to "#{url}"
    }
end

When(/^I request to (?:create|replace) (?:an?|the) ([^"]+?)(?: with (?:key|id))? "([^"]+)" with:$/) do |resource, id, params|
    resource_name = get_resource(resource)
    request_hash = get_attributes(params.hashes)
    json = MultiJson.dump(request_hash)
    url = get_url("#{resource_name}/#{id}")
    steps %Q{
        When I set JSON request body to:
            """
            #{json}
            """
        And I send a PUT request to "#{url}"
    }
end

# PATCH

When(/^I request to modify the (.+?)(?: with (?:key|id))? "([^"]+)" with:$/) do |resource, id, params|
    resource_name = get_resource(resource)
    request_hash = get_attributes(params.hashes)
    json = MultiJson.dump(request_hash)
    url = get_url("#{resource_name}/#{id}")
    steps %Q{
        When I set JSON request body to:
            """
            #{json}
            """
        And I send a PATCH request to "#{url}"
    }
end

# response interrogation

Then(/^the response has the following (?:data )?attributes:$/) do |table|
    expected = get_attributes(table.hashes)
    data = @response.get_as_type get_root_json_path(), 'object'
    raise %/Expected output to contain the provided attributes\n#{@response.to_json_s}/ if !data.deep_include?(expected)
end

Then(/^the response is a list (?:of|containing) (#{CAPTURE_INT}|\d+) .*?$/) do |count|
    steps %Q{
        Then the JSON response should have "#{get_root_json_path()}" of type array with #{count} entries
    }
end

Then(/^the response is a list (?:of|containing) (?:at least|more than) (#{CAPTURE_INT}|\d+) .*?$/) do |count|
    list = @response.get_as_type get_root_json_path(), 'array'
    raise %/Expected at least #{number} items in array for path '#{get_root_json_path()}', found: #{list.count}\n#{@repsponse.to_json_s}/ if list.count < count.to_i
end

Then(/(#{CAPTURE_INT}|\d+) (?:.*?) ha(?:s|ve) the following (?:data )?attributes:$/) do |count, params|
  expected_item = get_attributes(params.hashes)
  data = @response.get_as_type get_root_json_path(), 'array'
  matched_items = data.select { |item| item.deep_include?(expected_item) }
  raise %/Expected #{count} items in array with attributes, found: #{matched_items.count}\n#{@response.to_json_s}/ if matched_items.count != count
end

# value capture

When(/^I save (?:attribute )?"([^"]+)"$/) do |attribute|
    steps %Q{When I grab "#{get_json_path(attribute)}"}
end

When(/^I save (?:attribute )?"([^"]+)" to "([^"]+)"$/) do |attribute, ref|
    steps %Q{When I grab "#{get_json_path(attribute)}" as "#{ref}"}
end
