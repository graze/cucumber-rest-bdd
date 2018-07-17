require 'cucumber-rest-bdd/types'

# gets the relevant key for the response based on the first key element
def get_key(grouping)
  error_key = ENV['error_key']
  if error_key && !error_key.empty? && grouping.count > 1 && grouping[-2][:key].singularize == error_key
    '$.'
  else
    root_data_key
  end
end

# top level has 2 children
#   with an item containing
#   at most three fish with attributes:
#
# nesting = [
#   {key=fish,count=3,count_mod='<=',type=multiple},
#   {key=item,type=single},
#   {key=children,type=multiple,count=2,count_mod='='},
#   {root=true,type=single}
# ]
#
# returns true if the expected data is contained within the data based on the
# nesting information
def nest_match_attributes(data, nesting, expected, match_value)
  # puts data.inspect, nesting.inspect, expected.inspect, match_value.inspect
  return false unless data
  return data.deep_include?(expected) if !match_value && nesting.empty?
  return data.include?(expected) if match_value && nesting.empty?

  local_nesting = nesting.dup
  level = local_nesting.pop
  child_data = get_child_data(level, data)

  nest_get_match(level, child_data, local_nesting, expected, match_value)
end

# nest_get_match returns true if the child data matches the expected data
def nest_get_match(level, child_data, local_nesting, expected, match_value)
  case level[:type]
  when 'single' then
    nest_match_attributes(child_data, local_nesting, expected, match_value)
  when 'multiple' then
    child_check(level, child_data, local_nesting, expected, match_value)
  when 'list' then
    child_is_list(level, child_data)
  else
    raise %(Unknown nested data type: #{level[:type]})
  end
end

# check that all the children in child_data match the expected values
def child_check(level, child_data, local_nesting, expected, match_value)
  matched = child_data.select do |item|
    nest_match_attributes(item, local_nesting, expected, match_value)
  end
  level[:comparison].compare(matched.count)
end

# is the child a list, and does it match the comparison?
def child_is_list(level, child_data)
  child_data.is_a?(Array) \
  && (!level.key?(:comparison) \
    || level[:comparison].compare(child_data.count))
end

# parse the field and get the data for a given child
def get_child_data(level, data)
  return data.dup if level[:root]
  level_key = case level[:type]
              when 'single' then parse_field(level[:key])
              when 'multiple', 'list' then parse_list_field(level[:key])
              end
  raise %(Key not found: #{level[:key]} as #{level_key} in #{data}) \
    if data.is_a?(Array) || !data[level_key]
  data[level_key]
end
