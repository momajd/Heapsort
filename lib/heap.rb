require 'byebug'

class BinaryMinHeap
  def initialize(&prc)
    @store = []
    @prc = prc ||= Proc.new {|el1, el2| el1 <=> el2}
  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[count-1] = @store[count-1], @store[0]
    extracted = @store.pop
    BinaryMinHeap.heapify_down(@store, 0, &@prc)
    extracted
  end

  def peek
    @store[0]
  end

  def push(val)
    @store << val
    BinaryMinHeap.heapify_up(@store, count - 1, &@prc)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    [2 * parent_index + 1, 2 * parent_index + 2].select {|child| child < len }
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0
    child_index.odd? ? (child_index - 1) / 2 : (child_index - 2) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new {|el1, el2| el1 <=> el2}

    l_child_idx, r_child_idx = self.child_indices(len, parent_idx)
    return array if l_child_idx.nil? && r_child_idx.nil?

    l_child = array[l_child_idx] if l_child_idx
    r_child = array[r_child_idx] if r_child_idx

    if r_child.nil? || prc.call(l_child, r_child) == -1
      swap_idx = l_child_idx
    else
      swap_idx = r_child_idx
    end

    if prc.call(array[parent_idx], array[swap_idx]) == 1
      array[parent_idx], array[swap_idx] = array[swap_idx], array[parent_idx]
      self.heapify_down(array, swap_idx, len, &prc)
    end

    array
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new {|el1, el2| el1 <=> el2}

    return array if child_idx == 0

    child = array[child_idx]
    parent_idx = self.parent_index(child_idx)
    parent = array[parent_idx]

    if prc.call(child, parent) == -1
      array[child_idx], array[parent_idx] = parent, child
      self.heapify_up(array, parent_idx, len, &prc)
    end
    array
  end
end
