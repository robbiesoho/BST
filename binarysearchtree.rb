require 'pry'

class Node
  include Comparable
  attr_accessor :data, :left, :right, :parent_node

  def initialize(data, parent_node = nil)
    @data = data
    @left = nil
    @right = nil
    @parent_node = parent_node
  end

  # def <=>(other)
  #   @data <=> other.data
  # end

end

def remove_dups(array)
  new_array = []

  array.each do |x|
    new_array << x unless new_array.include?(x)
  end
end

def build_tree(array, parent = nil)
  root_value = array[0]
  if array.length == 0
    return
  elsif array.length == 1 
    root = Node.new(array[0], parent)
  elsif array.length == 2
    if array[1] > root_value
      root = Node.new(root_value, parent)
      root.right = Node.new(array[1], root)
    else
      root = Node.new(root_value, parent)
      root.left = Node.new(array[1], root)
    end  
  else
    left_side = []
    right_side = []
    for i in 0...array.length
      if array[i] < root_value
        left_side << array[i]
      elsif array[i] > root_value
        right_side << array[i]
      end
    end

  root = Node.new(root_value, parent)
  root.left = build_tree(left_side, root)
  root.right = build_tree(right_side, root)

  end
  root

end

def build_tree(array, parent = nil)
  root_value = array[0]
  if array.length == 0
    return
  elsif array.length == 1 
    root = Node.new(array[0], parent)
  elsif array.length == 2
    if array[1] > root_value
      root = Node.new(root_value, parent)
      root.right = Node.new(array[1], root)
    else
      root = Node.new(root_value, parent)
      root.left = Node.new(array[1], root)
    end  
  else
    left_side = []
    right_side = []
    for i in 0...array.length
      if array[i] < root_value
        left_side << array[i]
      elsif array[i] > root_value
        right_side << array[i]
      end
    end

  root = Node.new(root_value, parent)
  root.left = build_tree(left_side, root)
  root.right = build_tree(right_side, root)

  end
  root

end

def build_tree2(array, start=0, last=0)
  #binding.pry  
  return nil if start > last
  #sorts and removes duplicates
  array.sort!.uniq!
  start = 0
  last = array.size
  mid = (start + last)/2
  if array[mid] != nil #this line removes empty nodes
    root = Node.new(array[mid])
    left = array[start...mid]
    right = array[mid + 1..last]
  
    root.left = build_tree2(left, start, mid - 1)
    root.right = build_tree2(right, mid + 1, last)
  end 
  return root
end

class Tree
  attr_reader :root
  def initialize(array)
    @root = build_tree(remove_dups(array))
  end

  def inorder(root=@root)
    if root
      inorder(root.left)
      puts(root.data)
      inorder(root.right)
    end
  end

  def insert(root=@root, value)
    if root == nil
      root = Node.new(value)
    else
      
      if root.data > value
        if root.left == nil
          root.left = Node.new(value)
          root.left 
        else
          insert(root.left, value)
        end
      else
        if root.right == nil
          root.right = Node.new(value)
          root.right
        else
          insert(root.right, value)
        end
      end

    end
    

  end

  def delete(root=@root, value)
    if root.data == nil
      return root
    elsif root.data < value
      delete(root.right, value)
    elsif root.data > value
      delete(root.left, value)
    else
      # no child node
      if root.right == nil && root.left == nil
        if root.data > root.parent_node.data
          root.parent_node.right = nil
        else
          root.parent_node.left = nil
        end
      
      # 1 child
      elsif root.left == nil
        tmp = root.right
        root.parent_node.right = tmp
        tmp.parent_node = root.parent_node
   
      elsif root.right == nil
        tmp = root.left
        root.parent_node.left = tmp
        tmp.parent_node = root.parent_node

      # 2 children
      else
        tmp = root.right

        #find lowest value on right sided subtree
        while true
          if tmp.left
            tmp = tmp.left
          else
            break
          end
        end

        tmp.parent_node = root.parent_node
        tmp.left = root.left
        root.left.parent_node = tmp
        if tmp.data < tmp.parent_node.data
          tmp.parent_node.left = tmp
        else
          tmp.parent_node.right = tmp
        end


      end
    end

  end

  def find(value)
    tmp = @root
    
    while (tmp != nil) && (tmp.data != value) 
      if tmp.data > value
        tmp = tmp.left
      else
        tmp = tmp.right
      end
    end

    if tmp == nil
      puts "#{value} not found"
    else
      tmp
    end
  end
  
  
  
  def find_height(root=@root)
    if root == nil
      return 0
    else

      lheight = find_height(root.left)
      rheight = find_height(root.right)
    end

    if lheight > rheight
      return lheight + 1
    else
      return rheight + 1
    end
  end

  def level_order(root = @root)
    output = []
    queue = [@root]
    until queue.length == 0
      node = queue.pop
      if block_given?
        yield(node)
      else
        output << node.data
      end
      queue.unshift(node.left) if node.left
      queue.unshift(node.right) if node.right
    end
    unless block_given?
      output
    end
  end


  def inorder(root=@root)
    output = []
    stack = [@root]
    while !stack.empty?
      while root.left != nil
        stack.push(root.left)
        root = root.left
      end
      node = stack.pop
      if block_given?
        yield(node) 
      else
        output << node.data
      end
      if node.right
        stack.push(node.right)
        root = node.right
      end
    end

    unless block_given?
      output
    end
  end

  def inorder_rec(root=@root, output = [], &block)
    return if root == nil
    inorder_rec(root.left, output, &block)
    output << root.data if !block_given?
    yield(root) if block_given?
    inorder_rec(root.right, output, &block)
    return output if !block_given?
  end

  def preorder_rec(root=@root, output = [], &block)
    return if root == nil
    output << root.data if !block_given?
    yield(root) if block_given?
    preorder_rec(root.left, output, &block)
    preorder_rec(root.right, output, &block)
    return output if !block_given?
  end

  def postorder_rec(root=@root, output = [], &block)
      return if root == nil
      preorder_rec(root.left, output, &block)
      preorder_rec(root.right, output, &block)
      output << root.data if !block_given?
      yield(root) if block_given?
      return output if !block_given?
  end

  def is_balanced?(root=@root)
    if root == nil
      return true
    else
      heightL = find_height(root.left)
      heightR = find_height(root.right)
    end

    if ((heightL - heightR).abs <= 1) && is_balanced?(root.left) && is_balanced?(root.right)
      return true
    end
    return false
  end

  # build_balence_tree()

  def rebalance!(root=@root)
    temp = self.level_order
    @root = build_tree2(temp)
    
  end



  def rebalance2!(root=@root)
    temp = self.level_order
    @root = build_tree2(temp)
  end
   
  def balanced2?(level=0)
    node = @root
    return if node == nil
    level += 1
    right = find_height(node.right)
    left = find_height(node.left)

    if left == right || left + 1 == right || left - 1 == right
      return true
    else
      return false
    end
  end



end

  

bal_array = [7 ,5 ,6 ,8 ,10]
not_bal = [10,9,8,7,6,5]
test_array = [10,7,14,20,1,5,8]

[10, 7, 14, 20, 1, 5, 8]

[1, 5, 7, 8, 10, 14, 20]

test_array1  = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

#random test
tree = Tree.new(Array.new(15){rand(1..100)})
puts "Tree balanced: #{tree.balanced2?}."
print "Level order:"
tree.level_order{ |x| print " #{x.data}" }
puts
print "Preorder:"
tree.preorder_rec{ |x| print " #{x.data}" }
puts
print "Inorder:"
tree.inorder{ |x| print " #{x.data}" }
puts
print "Postorder:"
tree.postorder_rec{ |x| print " #{x.data}" }
puts
tree.insert(105)
puts "Added!"
tree.insert(107)
puts "Added!"
tree.insert(109)
puts "Added!"
puts "Tree balanced: #{tree.balanced2?}."
puts "Reobalancing tree..."
tree.rebalance!
puts "Tree balanced: #{tree.balanced2?}."
print "Level order:"
tree.level_order{ |x| print " #{x.data}" }
puts
print "Preorder:"
tree.preorder_rec{ |x| print " #{x.data}" }
puts
print "Inorder:"
tree.inorder{ |x| print " #{x.data}" }
puts
print "Postorder:"
tree.postorder_rec{ |x| print " #{x.data}" }
puts


def pretty_print(node = root, prefix="", is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? "│   " : "    "}", false) if node.right
  puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.data.to_s}"
  pretty_print(node.left, "#{prefix}#{is_left ? "    " : "│   "}", true) if node.left
end

pretty_print(tree.root)



# new_tree = Tree.new(test_array)
# p new_tree.is_balanced?()
# new_tree.delete(7)
# new_tree.find(80)
# new_tree.inorder()
# p new_tree.find_height()

# p new_tree.level_order() {|x| puts "The data for node #{x} is #{x.data}."}

# p new_tree.level_order() {|x| puts "The data for node #{x} is #{x.data}."}
# p new_tree.level_order() 


# p new_tree.inorder(){|x| puts "The data for node #{x} is #{x.data}."}

# # p new_tree.inorder()
# p new_tree.inorder_rec()
# p new_tree.inorder_rec(){|x| puts "The data for node #{x} is #{x.data}."}

# p new_tree.preorder_rec(){|x| puts "The data for node #{x} is #{x.data}."}
# p new_tree.postorder_rec(){|x| puts "The data for node #{x} is #{x.data}."}
# bal_tree = Tree.new(bal_array)
# p bal_tree.is_balanced?()

# build_tree(array, parent = nil)

# notballtree = Tree.new(not_bal)
# p notballtree.balanced2?()


# notballtree.rebalance2!
# p notballtree.balanced2?()

# newt2 = notballtree.rebalance!



# p newTree = Tree.new(newt)
# p newTree.is_balanced?
# p notballtree.rebalance2!

# p notballtree.level_order()
# p notballtree.inorder()



# p first.is_balanced?()
# p second = notballtree.rebalance2!
# p second.is_balanced?