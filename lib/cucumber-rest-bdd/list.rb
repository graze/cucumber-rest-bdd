require 'cucumber-rest-bdd/types'

HAVE_ALTERNATION = 'has/have/having/contain/contains/containing/with'.freeze
FEWER_MORE_THAN_SYNONYM = '(?:fewer|less|more)\sthan|at\s(?:least|most)'.freeze
INT_AS_WORDS_SYNONYM = 'zero|one|two|three|four|five|six|seven|eight|nine|ten'
                       .freeze
MAXIMAL_FIELD_NAME_SYNONYM = '\w+\b(?:(?:\s+:)?\s+\w+\b)*|`[^`]*`'.freeze

ParameterType(
  name: 'list_has_count',
  regexp: /a|an|(?:(?:#{FEWER_MORE_THAN_SYNONYM})\s+)?(?:#{INT_AS_WORDS_SYNONYM}|\d+)/,
  transformer: lambda { |match|
    matches = /(?:(#{FEWER_MORE_THAN_SYNONYM})\s+)?
              (#{INT_AS_WORDS_SYNONYM}|\d+)/x.match(match)
    return ListCountComparison.new(matches[1], matches[2])
  },
  use_for_snippets: false
)

ParameterType(
  name: 'list_nesting',
  # rubocop:disable Metrics/LineLength
  regexp: /(?:(?:#{HAVE_ALTERNATION.split('/').join('|')})?\s*(?:a list of\s+)?(?:a|an|(?:(?:#{FEWER_MORE_THAN_SYNONYM})\s+)?(?:#{INT_AS_WORDS_SYNONYM}|\d+))\s+(?:#{FIELD_NAME_SYNONYM})\s*)+/,
  # rubocop:enable Metrics/LineLength
  transformer: ->(match) { ListNesting.new(match) },
  use_for_snippets: false
)

# Handle many children within objects or lists
class ListNesting
  def initialize(match)
    @match = match
    # gets an array in the nesting format that nest_match_attributes understands
    # to interrogate nested object and array data
    grouping = []
    nesting = match

    minimal_list = /(?:#{HAVE_ALTERNATION.split('/').join('|')})?\s*
                   (?:(a\slist\sof)\s+)?(?:a|an|(?:(#{FEWER_MORE_THAN_SYNONYM})
                   \s+)?(#{INT_AS_WORDS_SYNONYM}|\d+))\s+
                   (#{FIELD_NAME_SYNONYM})/x
    maximal_list = /(?:#{HAVE_ALTERNATION.split('/').join('|')})?\s*
                   (?:(a\slist\sof)\s+)?(?:a|an|(?:(#{FEWER_MORE_THAN_SYNONYM})
                   \s+)?(#{INT_AS_WORDS_SYNONYM}|\d+))\s+
                   (#{MAXIMAL_FIELD_NAME_SYNONYM})/x
    while (matches = minimal_list.match(nesting))
      next_matches = minimal_list.match(nesting[matches.end(0), nesting.length])
      to_match = if next_matches.nil?
                   nesting
                 else
                   nesting[0, matches.end(0) + next_matches.begin(0)]
                 end
      matches = maximal_list.match(to_match)
      nesting = nesting[matches.end(0), nesting.length]

      level = if matches[1].nil?
                if matches[3].nil?
                  {
                    type: 'single',
                    key: matches[4],
                    root: false
                  }
                else
                  {
                    type: 'multiple',
                    key: matches[4],
                    comparison: ListCountComparison.new(matches[2], matches[3]),
                    root: false
                  }
                end
              else
                {
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

  attr_reader :match

  attr_reader :grouping
end

# Store a value and a comparison operator to determine if a provided number
# validates against it
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

  attr_reader :type

  def amount
    amount
  end

  # turn a comparison into a string
  def compare_to_string
    case @type
    when CMP_LESS_THAN then 'fewer than '
    when CMP_MORE_THAN then 'more than '
    when CMP_AT_LEAST then 'at least '
    when CMP_AT_MOST then 'at most '
    when CMP_EQUALS then 'exactly '
    else ''
    end
  end

  def to_string
    compare_to_string + ' ' + @amount.to_s
  end
end

CMP_LESS_THAN = '<'.freeze
CMP_MORE_THAN = '>'.freeze
CMP_AT_LEAST = '>='.freeze
CMP_AT_MOST = '<='.freeze
CMP_EQUALS = '='.freeze

# take a number modifier string (fewer than, less than, etc) and return an
# operator '<', etc
def to_compare(compare)
  case compare
  when 'fewer than' then CMP_LESS_THAN
  when 'less than' then CMP_LESS_THAN
  when 'more than' then CMP_MORE_THAN
  when 'at least' then CMP_AT_LEAST
  when 'at most' then CMP_AT_MOST
  else CMP_EQUALS
  end
end

def to_num(num)
  if num =~ /^(?:zero|one|two|three|four|five|six|seven|eight|nine|ten)$/
    return %w[zero one two three four five six seven eight nine ten].index(num)
  end

  num.to_i
end
