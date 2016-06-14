class DoubleLinkedList
  include Enumerable

  Node = Struct.new(:value, :next, :prev, :position)

  def initialize
    @head = nil
    @container = []
  end

  def <<(value)
    node = Node.new(value)
    node.prev = @head
    node.position = @container.size.next

    @head.next = node if @head

    @container << node

    @head = node
  end

  def each
    if block_given?
      @container.each { |n| yield(n) }
    else
      @container.each
    end
  end
end
