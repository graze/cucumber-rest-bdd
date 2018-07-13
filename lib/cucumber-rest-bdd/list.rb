require 'cucumber-rest-bdd/types'

FEWER_MORE_THAN_SYNONYM = %q{(?:fewer|less|more) than|at (?:least|most)}
INT_AS_WORDS_SYNONYM = %q{zero|one|two|three|four|five|six|seven|eight|nine|ten}

ParameterType(
    name: 'list_has_count',
    regexp: /a|an|(?:(?:#{FEWER_MORE_THAN_SYNONYM})\s+)?(?:#{INT_AS_WORDS_SYNONYM}|\d+)/,
    transformer: -> (match) {
        matches = /(?:(#{FEWER_MORE_THAN_SYNONYM})\s+)?(#{INT_AS_WORDS_SYNONYM}|\d+)/.match(match)
        return ListCountComparison.new(matches[1], matches[2])
    },
    use_for_snippets: false
)

ParameterType(
    name: 'list_nesting',
    regexp: %r{(?:(?:#{HAVE_ALTERNATION.split('/').join('|')})?\s*(?:a list of\s+)?(?:a|an|(?:(?:#{FEWER_MORE_THAN_SYNONYM})\s+)?(?:#{INT_AS_WORDS_SYNONYM}|\d+))\s+(?:#{FIELD_NAME_SYNONYM})\s*)+},
    transformer: -> (match) { ListNesting.new(match) },
    use_for_snippets: false
)

class ListNesting
    def initialize(match)
        @match = match
        # gets an array in the nesting format that nest_match_attributes understands to interrogate nested object and array data
        grouping = []
        nesting = match

        minimalListRegex = %r{(?:#{HAVE_ALTERNATION.split('/').join('|')})?\s*(?:(a list of)\s+)?(?:a|an|(?:(#{FEWER_MORE_THAN_SYNONYM})\s+)?(#{INT_AS_WORDS_SYNONYM}|\d+))\s+(#{FIELD_NAME_SYNONYM})}
        maximalListRegex = %r{(?:#{HAVE_ALTERNATION.split('/').join('|')})?\s*(?:(a list of)\s+)?(?:a|an|(?:(#{FEWER_MORE_THAN_SYNONYM})\s+)?(#{INT_AS_WORDS_SYNONYM}|\d+))\s+(#{MAXIMAL_FIELD_NAME_SYNONYM})}
        while matches = minimalListRegex.match(nesting)
            nextMatches = minimalListRegex.match(nesting[matches.end(0), nesting.length])
            matches = maximalListRegex.match(nextMatches.nil? ? nesting : nesting[0, matches.end(0) + nextMatches.begin(0)])
            nesting = nesting[matches.end(0), nesting.length]

            if matches[1].nil? then
                if matches[3].nil? then
                    level = {
                        type: 'single',
                        key: matches[4],
                        root: false
                    }
                else
                    level = {
                        type: 'multiple',
                        key: matches[4],
                        comparison: ListCountComparison.new(matches[2], matches[3]),
                        root: false
                    }
                end
            else
                level = {
                    type: 'list',
                    key: matches[4],
                    comparison: ListCountComparison.new(matches[2], matches[3]),
                    root: false
                }
            end
            grouping.push(level)
        end
        @grouping = grouping.reverse
    end

    def push(node)
        @grouping.push(node)
    end

    def match
        return @match
    end

    def grouping
        @grouping
    end
end

class ListCountComparison

    def initialize(type, amount)
        @type = type.nil? ? CMP_EQUALS : to_compare(type)
        @amount = amount.nil? ? 1 : to_num(amount)
    end

    def compare(actual)
        case @type
            when CMP_LESS_THAN then actual < @amount
            when CMP_MORE_THAN then actual > @amount
            when CMP_AT_MOST then actual <= @amount
            when CMP_AT_LEAST then actual >= @amount
            when CMP_EQUALS then actual == @amount
            else actual == @amount
        end
    end

    def type
        return @type
    end

    def amount
        return amount
    end

    # turn a comparison into a string
    def compare_to_string()
        case @type
        when CMP_LESS_THAN then 'fewer than '
        when CMP_MORE_THAN then 'more than '
        when CMP_AT_LEAST then 'at least '
        when CMP_AT_MOST then 'at most '
        when CMP_EQUALS then 'exactly '
        else ''
        end
    end

    def to_string()
        return compare_to_string() + ' ' + @amount.to_s
    end
end

CMP_LESS_THAN = '<'
CMP_MORE_THAN = '>'
CMP_AT_LEAST = '>='
CMP_AT_MOST = '<='
CMP_EQUALS = '='

# take a number modifier string (fewer than, less than, etc) and return an operator '<', etc
def to_compare(compare)
    return case compare
    when 'fewer than' then CMP_LESS_THAN
    when 'less than' then CMP_LESS_THAN
    when 'more than' then CMP_MORE_THAN
    when 'at least' then CMP_AT_LEAST
    when 'at most' then CMP_AT_MOST
    else CMP_EQUALS
    end
end

def to_num(num)
    if /^(?:zero|one|two|three|four|five|six|seven|eight|nine|ten)$/.match(num)
        return %w(zero one two three four five six seven eight nine ten).index(num)
    end
    return num.to_i
end
