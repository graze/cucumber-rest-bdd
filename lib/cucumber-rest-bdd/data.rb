require 'cucumber-rest-bdd/types'

# gets the relevant key for the response based on the first key element
def get_key(grouping)
    errorKey = ENV['error_key']
    if errorKey && !errorKey.empty? && grouping.count > 1 && grouping[-2][:key].singularize == errorKey then
        return "$."
    else
        return get_root_data_key()
    end
end

# top level has 2 children with an item containing at most three fish with attributes:
#
# nesting = [{key=fish,count=3,count_mod='<=',type=multiple},{key=item,type=single},{key=children,type=multiple,count=2,count_mod='='},{root=true,type=single}]
#
# returns true if the expected data is contained within the data based on the nesting information
def nest_match_attributes(data, nesting, expected, matchValue)
    return false if !data
    return data.deep_include?(expected) if !matchValue && nesting.size == 0
    return data.include?(expected) if matchValue && nesting.size == 0

    local_nesting = nesting.dup
    level = local_nesting.pop
    child_data = get_child_data(level, data)

    case level[:type]
        when 'single' then
            return nest_match_attributes(child_data, local_nesting, expected, matchValue)
        when 'multiple' then
            matched = child_data.select { |item| nest_match_attributes(item, local_nesting, expected, matchValue) }
            return level[:comparison].compare(matched.count)
        when 'list' then
            return child_data.is_a?(Array) && (!level.has_key?(:comparison) || level[:comparison].compare(child_data.count))
        else
            raise %/Unknown nested data type: #{level[:type]}/
    end
end

def get_child_data(level, data)
    if (level[:root]) then
        return data.dup
    else
        levelKey = case level[:type]
            when 'single' then get_field(level[:key])
            when 'multiple' then get_list_field(level[:key])
            when 'list' then get_list_field(level[:key])
        end
        raise %/Key not found: #{level[:key]} as #{levelKey} in #{data}/ if data.is_a?(Array) || !data[levelKey]
        return data[levelKey]
    end
end
