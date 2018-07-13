require 'cucumber-api/response'
require 'cucumber-api/steps'
require 'active_support/inflector'
require 'cucumber-rest-bdd/url'
require 'cucumber-rest-bdd/types'
require 'cucumber-rest-bdd/level'
require 'cucumber-rest-bdd/hash'
require 'easy_diff'

GET_TYPES = %{(?:an?(?! list)|the)}%
WITH_ID = %{(?: with (?:key|id))? "([^"]*)"}%

Given("I am a client") do
    steps %Q{
      Given I send "application/json" and accept JSON
    }
end

Given("I am issuing requests for {resource_name}") do |resource|
    @urlbasepath = resource
end

# GET

When("I request the {resource_name} (with key/id ){string}{levels}") do |resource, id, levels|
    url = get_url("#{levels.url}#{resource}/#{id}")
    steps %Q{When I send a GET request to "#{url}"}
end

When("I request the {resource_name} (with key/id ){string}{levels} with:") do |resource, id, levels, params|
    url = get_url("#{levels.url}#{resource}/#{id}")
    unless params.raw.empty?
        query = params.raw.map{|key, value| %/#{get_field(key)}=#{resolve(value)}/}.join("&")
        url = "#{url}?#{query}"
    end
    steps %Q{When I send a GET request to "#{url}"}
end

When("I request a list of {resource_name}{levels}") do |resource, levels|
    url = get_url("#{levels.url}#{resource}")
    steps %Q{When I send a GET request to "#{url}"}
end

When("I request a list of {resource_name}{levels} with:") do |resource, levels, params|
    url = get_url("#{levels.url}#{resource}")
    unless params.raw.empty?
        query = params.raw.map{|key, value| %/#{get_field(key)}=#{resolve(value)}/}.join("&")
        url = "#{url}?#{query}"
    end
    steps %Q{When I send a GET request to "#{url}"}
end

# DELETE

When("I request to delete/remove a/an/the {resource_name} (with key/id ){string}{levels}") do |resource, id, levels|
    url = get_url("#{levels.url}#{resource}/#{id}")
    steps %Q{When I send a DELETE request to "#{url}"}
end

# POST

When("I request to create a/an/the {resource_name}{levels}") do |resource, levels|
    if ENV['set_parent_id'] == 'true'
        json = MultiJson.dump(levels.last_hash)
        steps %Q{
            When I set JSON request body to:
            """
            #{json}
            """
        }
    end
    url = get_url("#{levels.url}#{resource}")
    steps %Q{When I send a POST request to "#{url}"}
end

When("I request to create a/an/the {resource_name}{levels} with:") do |resource, levels, params|
    request_hash = get_attributes(params.hashes)
    request_hash = request_hash.merge(levels.last_hash) if ENV['set_parent_id'] == 'true'
    json = MultiJson.dump(request_hash)
    url = get_url("#{levels.url}#{resource}")
    steps %Q{
        When I set JSON request body to:
            """
            #{json}
            """
        And I send a POST request to "#{url}"
    }
end

# PUT

When("I request to replace/set a/an/the {resource_name} (with key/id ){string}{levels}") do |resource, id, levels|
    if ENV['set_parent_id'] == 'true'
        json = MultiJson.dump(levels.last_hash)
        steps %Q{
            When I set JSON request body to:
            """
            #{json}
            """
        }
    end
    url = get_url("#{levels.url}#{resource}/#{id}")
    steps %Q{
        When I send a PUT request to "#{url}"
    }
end

When("I request to replace/set a/an/the {resource_name} (with key/id ){string}{levels} with:") do |resource, id, levels, params|
    request_hash = get_attributes(params.hashes)
    request_hash = request_hash.merge(levels.last_hash) if ENV['set_parent_id'] == 'true'
    json = MultiJson.dump(request_hash)
    url = get_url("#{levels.url}#{resource}/#{id}")
    steps %Q{
        When I set JSON request body to:
            """
            #{json}
            """
        And I send a PUT request to "#{url}"
    }
end

# PATCH

When("I request to modify/update a/an/the {resource_name} (with key/id ){string}{levels} with:") do |resource, id, levels, params|
    request_hash = get_attributes(params.hashes)
    json = MultiJson.dump(request_hash)
    url = get_url("#{levels.url}#{resource}/#{id}")
    steps %Q{
        When I set JSON request body to:
            """
            #{json}
            """
        And I send a PATCH request to "#{url}"
    }
end

# value capture

When("I save (attribute ){string}") do |attribute|
    steps %Q{When I grab "#{get_json_path(attribute)}" as "#{attribute}"}
end

When("I save (attribute ){string} to {string}") do |attribute, ref|
    steps %Q{When I grab "#{get_json_path(attribute)}" as "#{ref}"}
end
