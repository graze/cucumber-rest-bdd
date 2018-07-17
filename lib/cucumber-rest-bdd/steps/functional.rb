require 'cucumber-api/response'
require 'cucumber-api/steps'
require 'cucumber-rest-bdd/types'
require 'cucumber-rest-bdd/list'

Then(
  'the response (should )have/has (a/the )header {string} '\
  "#{HAVE_ALTERNATION} (a/the )value {string}"
) do |header, value|
  p_value = resolve(value)
  p_header = header.parameterize
  unless @response.raw_headers.key?(p_header)
    raise %(Required header: #{header} not found
          #{@response.raw_headers.inspect})
  end
  unless @response.raw_headers[p_header].include? p_value
    raise %/Expect #{p_value} in #{header} (#{p_header})
          #{@response.raw_headers.inspect}/
  end
end

Then(
  'the JSON response should have {string} of type array '\
  "#{HAVE_ALTERNATION} {list_has_count} entry/entries"
) do |json_path, list_comparison|
  list = @response.get_as_type json_path, 'array'
  unless list_comparison.compare(list.count)
    raise %(Expected #{list_comparison.to_string} entries in array for path
          '#{json_path}', found: #{list.count}
          #{@response.to_json_s})
  end
end

Then(
  'the JSON response should have {string} of type {word} that matches {string}'
) do |json_path, type, regex|
  value = @response.get_as_type json_path, type
  if (Regexp.new(regex) =~ value).nil?
    raise %(Expected #{json_path} value '#{value}' to match regex: #{regex}
          #{@response.to_json_s})
  end
end

Then(
  'the JSON response should have {string} of type nill/null/nil'
) do |json_path|
  value = @response.get_as_type_or_null json_path, 'string'
  unless value.nil?
    raise %(Expected #{json_path} to be nil, was: #{value.class}
          #{@response.to_json_s})
  end
end
