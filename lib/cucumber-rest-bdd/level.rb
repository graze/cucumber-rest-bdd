require 'cucumber-rest-bdd/types'
require 'active_support/inflector'

LEVELS = %{(?: (?:for|in|on) [^"]+?(?: with (?:key|id))? "[^"]+")*}%

class Level
    @urls = []

    def initialize(levels)
        arr = []
        while matches = /^ (?:for|in|on) ([^"]+?)(?: with (?:key|id))? "([^"]*)"/.match(levels)
            levels = levels[matches[0].length, levels.length]
            item = {
                resource: get_resource(matches[1]),
                id: matches[2]
            }
            item[:id] = item[:id].to_i if item[:id].match(/^\d+$/)
            arr.append(item)
        end
        @urls = arr.reverse
    end

    def url
        @urls.map{ |l| "#{l[:resource]}/#{l[:id]}/"}.join()
    end

    def hash
        hash = {}
        @urls.each{ |l| hash[get_parameter("#{get_parameter(l[:resource]).singularize}_id")] = l[:id] }
        hash
    end

    def last_hash
        last = @urls.last
        if !last.nil?
            key = get_parameter("#{get_parameter(last[:resource]).singularize}_id")
            return {
                key => last[:id]
            }
        end
        return {}
    end

    def to_s
        self.url
    end
end
