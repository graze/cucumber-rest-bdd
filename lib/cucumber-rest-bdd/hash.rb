require 'easy_diff'

# Adds deep_include? to the Hash class
class Hash
  def deep_include?(other)
    diff = other.easy_diff(self)
    diff[0].delete_if { |_k, v| v.empty? if v.is_a?(::Hash) }
    diff[0].empty?
  end
end
