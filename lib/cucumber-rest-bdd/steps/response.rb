require 'cucumber-rest-bdd/steps/resource'
require 'cucumber-rest-bdd/types'

# response interrogation

Then(/^the response is a list (?:of|containing) (#{FEWER_MORE_THAN})?\s*(#{CAPTURE_INT}|\d+) .*?$/) do |count_mod, count|
    list = @response.get_as_type get_root_data_key(), 'array'
    raise %/Expected at least #{count} items in array for path '#{get_root_data_key()}', found: #{list.count}\n#{@response.to_json_s}/ if !num_compare(count_mod, list.count, count.to_i)
end

Then(/^the response ((?:#{HAVE_SYNONYM} (?:a|an|(?:(?:#{FEWER_MORE_THAN})?\s*#{CAPTURE_INT}|\d+)) (?:\w+) )*)#{HAVE_SYNONYM} (?:the )?(?:following )?(?:data|error )?attributes:$/) do |nesting, attributes|
    expected = get_attributes(attributes.hashes)
    groups = nesting
    grouping = get_grouping(groups)
    grouping.push({
        root: true,
        type: 'single'
    })
    data = @response.get get_key(grouping)
    raise %/Could not find a match for: #{nesting}\n#{expected.inspect}\n#{@response.to_json_s}/ if data.empty? || !nest_match(data, grouping, expected)
end

Then(/^the response ((?:#{HAVE_SYNONYM} (?:a|an|(?:(?:#{FEWER_MORE_THAN})?\s*#{CAPTURE_INT}|\d+)) (?:\w+)\s?)+)$/) do |nesting|
    groups = nesting
    grouping = get_grouping(groups)
    grouping.push({
        root: true,
        type: 'single'
    })
    data = @response.get get_key(grouping)
    raise %/Could not find a match for: #{nesting}\n#{@response.to_json_s}/ if data.empty? || !nest_match(data, grouping, {})
end

Then(/^(#{FEWER_MORE_THAN})?\s*(#{CAPTURE_INT}|\d+) (?:.*?) ((?:#{HAVE_SYNONYM} (?:a|an|(?:(?:#{FEWER_MORE_THAN})?\s*#{CAPTURE_INT}|\d+)) (?:\w+) )*)#{HAVE_SYNONYM} (?:the )?(?:following )?(?:data )?attributes:$/) do |count_mod, count, nesting, attributes|
    expected = get_attributes(attributes.hashes)
    groups = nesting
    grouping = get_grouping(groups)
    grouping.push({
        root: true,
        type: 'multiple',
        count: count.to_i,
        count_mod: count_mod
    })
    data = @response.get get_key(grouping)
    raise %/Expected #{compare_to_string(count_mod)}#{count} items in array with attributes for: #{nesting}\n#{expected.inspect}\n#{@response.to_json_s}/ if !nest_match(data, grouping, expected)
end

Then(/^(#{FEWER_MORE_THAN})?\s*(#{CAPTURE_INT}|\d+) (?:.*?) ((?:#{HAVE_SYNONYM} (?:a|an|(?:(?:#{FEWER_MORE_THAN})?\s*#{CAPTURE_INT}|\d+)) (?:\w+)\s?)+)$/) do |count_mod, count, nesting|
    groups = nesting
    grouping = get_grouping(groups)
    grouping.push({
        root: true,
        type: 'multiple',
        count: count.to_i,
        count_mod: count_mod
    })
    data = @response.get get_key(grouping)
    raise %/Expected #{compare_to_string(count_mod)}#{count} items in array with: #{nesting}\n#{@response.to_json_s}/ if !nest_match(data, grouping, {})
end

Then(/^the response ((?:#{HAVE_SYNONYM} (?:a|an|(?:(?:#{FEWER_MORE_THAN})?\s*#{CAPTURE_INT}|\d+)) (?:\w+) )*)#{HAVE_SYNONYM} a list of (#{FEWER_MORE_THAN})?\s*(#{CAPTURE_INT} |\d+ )?(\w+)$/) do |nesting, num_mod, num, item|
    groups = nesting
    list = {
        type: 'list',
        key: get_resource(item)
    }
    if (num) then
        list[:count] = num.to_i
        list[:count_mod] = num_mod
    end
    grouping = [list]
    grouping.concat(get_grouping(groups))
    grouping.push({
        root: true,
        type: 'single'
    })
    data = @response.get get_key(grouping)
    raise %/Could not find a match for #{nesting}#{compare_to_string(num_mod)}#{num} #{item}\n#{@response.to_json_s}/ if !nest_match(data, grouping, {})
end

Then(/^(#{FEWER_MORE_THAN})?\s*(#{CAPTURE_INT}|\d+) (?:.*?) ((?:#{HAVE_SYNONYM} (?:a|an|(?:(?:#{FEWER_MORE_THAN})?\s*#{CAPTURE_INT}|\d+)) (?:\w+) )*)#{HAVE_SYNONYM} a list of (#{FEWER_MORE_THAN})?\s*(?:(#{CAPTURE_INT}|\d+) )?(\w+)$/) do |count_mod, count, nesting, num_mod, num, item|
    groups = nesting
    list = {
        type: 'list',
        key: get_resource(item)
    }
    if (num) then
        list[:count] = num.to_i
        list[:count_mod] = num_mod
    end
    grouping = [list]
    grouping.concat(get_grouping(groups))
    grouping.push({
        root: true,
        type: 'multiple',
        count: count.to_i,
        count_mod: count_mod
    })
    data = @response.get get_key(grouping)
    raise %/Expected #{compare_to_string(count_mod)}#{count} items with #{nesting}#{compare_to_string(num_mod)}#{num}#{item}\n#{@response.to_json_s}/ if !nest_match(data, grouping, {})
end

# gets the relevant key for the response based on the first key element
def get_key(grouping)
    if ENV['error_key'] && !ENV['error_key'].empty? && grouping.count > 1 && grouping[-2][:key].singularize == ['error_key'] then
        get_root_error_key()
    else
        get_root_data_key()
    end
end

# gets an array in the nesting format that nest_match understands to interrogate nested object and array data
def get_grouping(nesting)
    grouping = []
    while matches = /^#{HAVE_SYNONYM} (?:a|an|(?:(#{FEWER_MORE_THAN})?\s*(#{CAPTURE_INT}|\d+))) (\w+)\s?+/.match(nesting)
        nesting = nesting[matches[0].length, nesting.length]
        if matches[2].nil? then
            level = {
                type: 'single',
                key: get_parameter(matches[3]),
                root: false
            }
        else
            level = {
                type: 'multiple',
                key: get_parameter(matches[3]),
                count: to_num(matches[2]),
                root: false,
                count_mod: to_compare(matches[1])
            }
        end
        grouping.push(level)
    end
    grouping.reverse
end

# top level has 2 children with an item containing at most three fish with attributes:
#
# nesting = [{key=fish,count=3,count_mod='<=',type=multiple},{key=item,type=single},{key=children,type=multiple,count=2,count_mod='='},{root=true,type=single}]
#
# returns true if the expected data is contained within the data based on the nesting information
def nest_match(data, nesting, expected)
    return false if !data
    return data.deep_include?(expected) if nesting.size == 0

    local_nesting = nesting.dup
    level = local_nesting.pop
    case level[:type]
    when 'single' then
        child_data = level[:root] ? data.dup : data[get_parameter(level[:key])]
        return nest_match(child_data, local_nesting, expected)
    when 'multiple' then
        child_data = level[:root] ? data.dup : data[get_resource(level[:key])]
        matched = child_data.select { |item| nest_match(item, local_nesting, expected) }
        return num_compare(level[:count_mod], matched.count, level[:count])
    when 'list' then
        child_data = level[:root] ? data.dup : data[get_resource(level[:key])]
        return false if !child_data.is_a?(Array)
        if level.has_key?(:count) then
            return num_compare(level[:count_mod], child_data.count, level[:count])
        end
        return true
    else
        raise %/Unknown nested data type: #{level[:type]}/
    end
end
