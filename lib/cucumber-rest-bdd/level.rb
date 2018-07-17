require 'cucumber-rest-bdd/types'
require 'active_support/inflector'

ParameterType(
  name: 'levels',
  regexp: /((?: (?:for|in|on) (?:#{RESOURCE_NAME_SYNONYM})(?: with (?:key|id))? "[^"]*")*)/,
  transformer: ->(levels) { Level.new(levels) },
  use_for_snippets: false
)

# Helper class when creating nested resources
class Level
  @urls = []

  def initialize(levels)
    arr = []
    while (matches = /^ (?:for|in|on) ([^"]+?)(?: with (?:key|id))? "([^"]*)"/
      .match(levels))
      levels = levels[matches[0].length, levels.length]
      item = { resource: get_resource(matches[1]), id: matches[2] }
      item[:id] = item[:id].to_i if item[:id] =~ /^\d+$/
      arr.append(item)
    end
    @urls = arr.reverse
  end

  def url
    @urls.map { |l| "#{l[:resource]}/#{l[:id]}/" }.join
  end

  def hash
    hash = {}
    @urls.each do |l|
      hash[parse_field("#{parse_field(l[:resource]).singularize}_id")] = l[:id]
    end
    hash
  end

  def last_hash
    last = @urls.last
    unless last.nil?
      key = parse_field("#{parse_field(last[:resource]).singularize}_id")
      return {
        key => last[:id]
      }
    end
    {}
  end

  def to_s
    url
  end
end
