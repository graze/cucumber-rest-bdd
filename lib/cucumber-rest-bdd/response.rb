require 'cucumber-api/response'
require 'cucumber-api/steps'

Then(/^the response should have header "([^"]*)" with value "([^"]*)"$/) do |header, value|
    p_value = resolve(value)
    raise %/Required header: #{header} not found/ if !@response.raw_headers.key?(header)
    actual = @response.raw_headers[header].first
    raise %/Expect #{p_value} but was #{actual}/ if actual != p_value
end

Then(/^the JSON response should have "([^"]*)" of type array with (\d+) entr(?:y|ies)$/) do |json_path, number|
  list = @response.get_as_type json_path, 'array'
  raise %/Expected #{number} items in array for path '#{json_path}', found: #{list.count}\n#{@repsponse.to_json_s}/ if list.count != number.to_i
end

Then(/^the JSON response should have "([^"]*)" of type (.+) that matches "(.+)"$/) do |json_path, type, regex|
    value = @response.get_as_type json_path, type
    raise %/Expected #{json_path} value '#{value}' to match regex: #{regex}\n#{@response.to_json_s}/ if (Regexp.new(regex) =~ value).nil?
end
