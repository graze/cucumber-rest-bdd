require 'active_support/inflector'

HAVE_ALTERNATION = 'has/have/having/contain/contains/containing/with'.freeze
RESOURCE_NAME_SYNONYM = '\w+\b(?:\s+\w+\b)*?|`[^`]*`'.freeze
FIELD_NAME_SYNONYM = '\w+\b(?:(?:\s+:)?\s+\w+\b)*?|`[^`]*`'.freeze
MAXIMAL_FIELD_NAME_SYNONYM = '\w+\b(?:(?:\s+:)?\s+\w+\b)*|`[^`]*`'.freeze

ParameterType(
  name: 'resource_name',
  regexp: /#{RESOURCE_NAME_SYNONYM}/,
  transformer: ->(s) { get_resource(s) },
  use_for_snippets: false
)

ParameterType(
  name: 'field_name',
  regexp: /#{FIELD_NAME_SYNONYM}/,
  transformer: ->(s) { ResponseField.new(s) },
  use_for_snippets: false
)

# Add Boolean module to handle types
module Boolean; end
# True
class TrueClass; include Boolean; end
# False
class FalseClass; include Boolean; end

# Add Enum module to handle types
module Enum; end
# Enum is a type of string
class String; include Enum; end

# Handle parsing a field from a response
class ResponseField
  def initialize(names)
    @fields = split_fields(names)
  end

  def to_json_path
    "#{root_data_key}#{@fields.join('.')}"
  end

  def get_value(response, type)
    response.get_as_type to_json_path, parse_type(type)
  end

  def validate_value(response, value, regex)
    raise "Expected #{json_path} value '#{value}' to match regex: #{regex}\n#{response.to_json_s}" \
      if (regex =~ value).nil?
  end
end

def parse_type(type)
  replacements = {
    /^numeric$/i => 'numeric',
    /^int$/i => 'numeric',
    /^long$/i => 'numeric',
    /^number$/i => 'numeric',
    /^decimal$/i => 'numeric',
    /^double$/i => 'numeric',
    /^bool$/i => 'boolean',
    /^null$/i => 'nil_class',
    /^nil$/i => 'nil_class',
    /^string$/i => 'string',
    /^text$/i => 'string'
  }
  type.tr(' ', '_')
  replacements.each { |k, v| type.gsub!(k, v) }
  type
end

def string_to_type(value, type)
  replacements = {
    /^numeric$/i => 'integer',
    /^int$/i => 'integer',
    /^long$/i => 'integer',
    /^number$/i => 'integer',
    /^decimal$/i => 'float',
    /^double$/i => 'float',
    /^bool$/i => 'boolean',
    /^null$/i => 'nil_class',
    /^nil$/i => 'nil_class',
    /^string$/i => 'string',
    /^text$/i => 'string'
  }
  type.tr(' ', '_')
  replacements.each { |k, v| type.gsub!(k, v) }
  type = type.camelize.constantize
  # cannot use 'case type' which checks for instances of a type rather than type equality
  if type == Boolean then !(value =~ /true|yes/i).nil?
  elsif type == Enum then value.upcase.tr(' ', '_')
  elsif type == Float then value.to_f
  elsif type == Integer then value.to_i
  elsif type == NilClass then nil
  else value
  end
end

def get_resource(name)
  if name[0] == '`' && name[-1] == '`'
    name = name[1..-2]
  else
    name = name.parameterize
    name = ENV.key?('resource_single') && ENV['resource_single'] == 'true' ? name.singularize : name.pluralize
  end
  name
end

def root_data_key
  ENV.key?('data_key') && !ENV['data_key'].empty? ? "$.#{ENV['data_key']}." : '$.'
end

def json_path(names)
  "#{root_data_key}#{split_fields(names).join('.')}"
end

def split_fields(names)
  names.split(':').map { |n| parse_field(n.strip) }
end

def parse_field(name)
  if name[0] == '`' && name[-1] == '`'
    name = name[1..-2]
  elsif name[0] != '[' || name[-1] != ']'
    separator = ENV.key?('field_separator') ? ENV['field_separator'] : '_'
    name = name.parameterize(separator: separator)
    name = name.camelize(:lower) if ENV.key?('field_camel') && ENV['field_camel'] == 'true'
  end
  name
end

def parse_list_field(name)
  if name[0] == '`' && name[-1] == '`'
    name = name[1..-2]
  elsif name[0] != '[' || name[-1] != ']'
    separator = ENV.key?('field_separator') ? ENV['field_separator'] : '_'
    name = name.parameterize(separator: separator)
    name = name.pluralize
    name = name.camelize(:lower) if ENV.key?('field_camel') && ENV['field_camel'] == 'true'
  end
  name
end

def parse_attributes(hashes)
  hashes.each_with_object({}) do |row, hash|
    name = row['attribute']
    value = row['value']
    type = row['type']
    value = resolve_functions(value)
    value = resolve(value)
    value.gsub!(/\\n/, "\n")
    names = split_fields(name)
    new_hash = names.reverse.inject(string_to_type(value, type)) { |a, n| add_to_hash(a, n) }
    hash.deep_merge!(new_hash) { |_, old, new| new.is_a?(Array) ? merge_arrays(old, new) : new }
  end
end

def resolve_functions(value)
  value.gsub!(/\[([a-zA-Z0-9_]+)\]/) do |s|
    s.gsub!(/[\[\]]/, '')
    case s.downcase
    when 'datetime'
      Time.now.strftime('%Y%m%d%H%M%S')
    else
      raise 'Unrecognised function ' + s + '?'
    end
  end
  value
end

def add_to_hash(hash, node)
  result = nil
  if node[0] == '[' && node[-1] == ']'
    array = Array.new(node[1..-2].to_i + 1)
    array[node[1..-2].to_i] = hash
    result = array
  end
  !result.nil? ? result : { node => hash }
end

def merge_arrays(first, second)
  new_length = [first.length, second.length].max
  new_array = Array.new(new_length)
  new_length.times do |n|
    new_array[n] = if second[n].nil?
                     first[n]
                   else
                     new_array[n] = if first[n].nil?
                                      second[n]
                                    else
                                      first[n].merge(second[n])
                                    end
                   end
  end
  new_array
end
