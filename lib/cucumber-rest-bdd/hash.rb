require 'easy_diff'

class Hash
    def deep_include?(other)
        diff = other.easy_diff(self)
        diff[0].delete_if { |k, v| v.empty? if v.is_a?(::Hash) }
        diff[0].empty?
    end
end
