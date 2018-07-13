require 'cucumber-api/response'
require 'cucumber-api/steps'
require 'cucumber-rest-bdd/types'
require 'cucumber-rest-bdd/list'

Then("the response (should )have/has (a/the )header {string} #{HAVE_ALTERNATION} (a/the )value {string}") do |header, value|
    p_value = resolve(value)
    p_header = header.parameterize
    raise %/Required header: #{header} not found\n#{@response.raw_headers.inspect}/ if !@response.raw_headers.key?(p_header)
    exists = @response.raw_headers[p_header].include? p_value
    raise %/Expect #{p_value} in #{header} (#{p_header})\n#{@response.raw_headers.inspect}/ if !exists
end

Then("the JSON response should have {string} of type array #{HAVE_ALTERNATION} {list_has_count} entry/entries") do |json_path, list_comparison|
  list = @response.get_as_type json_path, 'array'
  raise %/Expected #{list_comparison.to_string()} entries in array for path '#{json_path}', found: #{list.count}\n#{@response.to_json_s}/ if !list_comparison.compare(list.count)
end

Then("the JSON response should have {string} of type {word} that matches {string}") do |json_path, type, regex|
    value = @response.get_as_type json_path, type
    raise %/Expected #{json_path} value '#{value}' to match regex: #{regex}\n#{@response.to_json_s}/ if (Regexp.new(regex) =~ value).nil?
end

Then("the JSON response should have {string} of type nill/null/nil") do |json_path|
    value = @response.get_as_type_or_null json_path, 'string'
    raise %/Expected #{json_path} to be nil, was: #{value.class}\n#{@response.to_json_s}/ if !value.nil?
end
