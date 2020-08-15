# klass for hash map
class HashTable
  # constructor
  def initialize(size = nil)
    @size = size || 10
    @table = Array.new(@size)
  end
  
  def get value
    return if value.nil?

    hash_key = hash_function value.to_s
    @table[hash_key]
  end

  def set value
    return if value.nil?

    hash_key = hash_function value.to_s
    unless @table[hash_key].nil?
      @table[hash_key].append(value)
    else
      @table[hash_key] = [value]
    end
    true
  end

  private

  # generates hash_key
  # f = (first_value * value_size + last_value) % hash_size
  def hash_function value_s
    value_size = value_s.length
    (value_s[0].ord * value_size +  value_s[value_size - 1].ord) % @size
  end
end

hash_table = HashTable.new
puts hash_table.get("a")
puts hash_table.set("ab")
puts hash_table.set("abb")
puts hash_table.set("abc")
puts hash_table.set("abdd")
print hash_table.get("abd")