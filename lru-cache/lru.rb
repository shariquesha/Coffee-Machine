# lru cache class
class Lru
  # doubly linked list node
  class Node
    attr_accessor :value, :next, :prev, :key
    # constructor
    def initialize(key, value)
      @value = value
      @next = nil
      @prev = nil
      @key = key
    end
  end

  private_constant :Node

  def initialize(size)
    @table = {}
    @head = nil
    @tail = nil
    @size = size
    @node_counts = 0
    @least_recent_key = nil
  end

  # get a value from the cache
  def get(key)
    node = @table[key]
    return -1 if node.nil?

    make_most_recent_used(node)
    node.value
  end

  # set key value into cache
  def put(key, value)
    if @table[key].nil?
      insert_into_cache(key, value)
    else
      update_cache(key, value)
    end
  end

  private

  # deletes front node of DLL
  def evict_least_recently_used
    @node_counts -= 1
    @table.delete(@head.key)
    delete_front_node
  end

  # move given node to end of list
  def make_most_recent_used(node)
    return if node == @tail

    if node == @head
      @head = node.next
      @head.prev = nil
    else
      node.prev.next = node.next
      node.next.prev = node.prev
    end
    append_at_end(node)
  end

  def append_at_end(node)
    @tail.next = node
    node.prev = @tail
    node.next = nil
    @tail = node
  end

  def delete_front_node
    t = @head.next
    t.prev = nil
    @head.next = nil

    @head = t
  end

  def create_dll(new_node)
    @head = new_node
    @tail = new_node

    @head.next = @tail
    @tail.prev = @head
  end

  def insert_into_cache(key, value)
    evict_least_recently_used if @node_counts == @size
    new_node = Node.new(key, value)
    @table[key] = new_node
    @node_counts += 1
    @head.nil? ? create_dll(new_node) : append_at_end(new_node)
  end

  def update_cache(key, value)
    @table[key].value = value
    make_most_recent_used(@table[key])
  end
end
