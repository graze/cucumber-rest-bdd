require 'cucumber-api/response'
require 'cucumber-api/steps'

Then(/^the response (?:should have|has a|has the) header "([^"]*)" with (?:a |the )?value "([^"]*)"$/) do |header, value|
    p_value = resolve(value)
    p_header = header.parameterize
    raise %/Required header: #{header} not found\n#{@response.raw_headers.inspect}/ if !@response.raw_headers.key?(p_header)
    exists = @response.raw_headers[p_header].include? p_value
    raise %/Expect #{p_value} in #{header} (#{p_header})\n#{@response.raw_headers.inspect}/ if !exists
end

Then(/^the JSON response should have "([^"]*)" of type array with (\d+) entr(?:y|ies)$/) do |json_path, number|
  list = @response.get_as_type json_path, 'array'
  raise %/Expected #{number} items in array for path '#{json_path}', found: #{list.count}\n#{@response.to_json_s}/ if list.count != number.to_i
end

Then(/^the JSON response should have "([^"]*)" of type (.+) that matches "(.+)"$/) do |json_path, type, regex|
    value = @response.get_as_type json_path, type
    raise %/Expected #{json_path} value '#{value}' to match regex: #{regex}\n#{@response.to_json_s}/ if (Regexp.new(regex) =~ value).nil?
end
