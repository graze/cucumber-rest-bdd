require 'active_support/inflector'

CAPTURE_INT = Transform(/^(?:zero|one|two|three|four|five|six|seven|eight|nine|ten)$/) do |v|
  %w(zero one two three four five six seven eight nine ten).index(v)
end

module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

module Enum; end
class String; include Enum; end

class String
  def to_type(type)
    # cannot use 'case type' which checks for instances of a type rather than type equality
    if type == Boolean then self =~ /true/i
    elsif type == Date then Date.parse(self)
    elsif type == DateTime then DateTime.parse(self)
    elsif type == Enum then self.upcase.tr(" ", "_")
    elsif type == Float then self.to_f
    elsif type == Integer then self.to_i
    else self
    end
  end
end

def get_resource(name)
    resource = name.parameterize
    resource = (ENV.has_key?('resource_single') && ENV['resource_single'] == 'true') ? resource.singularize : resource.pluralize
end

def get_root_json_path()
    key = ENV.has_key?('data_key') && !ENV['data_key'].empty? ? %/$.#{ENV['data_key']}./ : "$."
end

def get_parameter(name)
    separator = ENV.has_key?('field_separator') ? ENV['field_separator'] : '_'
    name = name.parameterize(separator: separator)
    name = name.camelize(:lower) if (ENV.has_key?('field_camel') && ENV['field_camel'] == 'true')
    name
end

def get_attributes(hashes)
    attributes = hashes.each_with_object({}) do |row, hash|
      name, value, type = row["attribute"], row["value"], row["type"]
      value = resolve(value)
      value.gsub!(/\\n/, "\n")
      type.gsub!(/numeric/, 'integer')
      hash[get_parameter(name)] = value.to_type(type.camelize.constantize)
    end
end
