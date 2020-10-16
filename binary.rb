
#Build a Node class. It should have an attribute for the data it stores as well as its left and right children. 
#As a bonus, try including the Comparable module and compare nodes using their data attribute.
class Node
    include Comparable
    attr_accessor :data, :left, :right
  
    def initialize(data)
      @data = data
      @left = nil
      @right = nil
    end
end


#Build a Tree class which accepts an array when initialized. 
#The Tree class should have a root attribute which uses the return value of #build_tree which you’ll write next.
class Tree
    attr_accessor :root

    def initialize(arr)
      @arr = arr.uniq.sort
      @root = build_tree(arr, 0, @arr.length - 1)
    end


    #Write a #build_tree method which takes an array of data 
    #(e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) 
    #and turns it into a balanced binary tree full of Node objects appropriately placed 
    #(don’t forget to sort and remove duplicates!). The #build_tree method should return the level-1 root node.
    def build_tree(arr, start, last)
        return nil if start > last
        mid = (start + last)/2
        root = Node.new(arr[mid])
        root.left = build_tree(arr, start, mid-1)
        root.right = build_tree(arr, mid+1, last)
        root
    end


    #Write an #insert and #delete method which accepts a value to insert/delete 
    #(you’ll have to deal with several cases for delete such as when a node has children or not). 
    #If you need additional resources, check out these two articles on inserting and deleting, or this video with several visual examples.
    def insert(value, node = @root)
        return if value == node.data
    
        if value < node.data
          node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
        elsif node.right.nil?
          node.right = Node.new(value)
        else
          insert(value, node.right)
        end
    end


    def min_value_node(node)
        current = node
        current = current.left until current.left.nil?
        current
    end


    def delete(value, node = @root)
        return node if node.nil?
    
        if node.data < value
          node.right = delete(value, node.right)
          return node
        elsif node.data > value
          node.left = delete(value, node.left)
          return node
        else
    
          if node.left.nil?
            temp = node.right
            node = nil
            return temp
          elsif node.right.nil?
            temp = node.left
            node = nil
            return temp
          end
    
          temp = min_value_node(node.right)
          node.data = temp.data
          node.right = delete(temp.data, node.right)
        end
        node
    end


    #Write a #find method which accepts a value and returns the node with the given value.
    def find(value, node = @root)
        return nil if node.nil?
    
        if node.data < value
          find(value, node.right)
        elsif node.data > value
          find(value, node.left)
        else
          node
        end
    end


    #Write a #level_order method that returns an array of values. 
    #This method should traverse the tree in breadth-first level order. 
    #This method can be implemented using either iteration or recursion (try implementing both!). 
    #Tip: You will want to use an array acting as a queue to keep track of all the child nodes 
    #that you have yet to traverse and to add new ones to the list (as you saw in the video).
    def level_order(node = @root, values = [])
        return nil if node.nil?
    
        queue = []
        queue.append(node)
        until queue.empty?
          current = queue.shift
          queue.append(current.left) unless current.left.nil?
          queue.append(current.right) unless current.right.nil?
          values.append(current.data)
        end
        values
    end


    #Write #inorder, #preorder, and #postorder methods that returns an array of values. 
    #Each method should traverse the tree in their respective depth-first order.
    def inorder(node = @root, values = [])
        return nil if node.nil?
    
        inorder(node.left, values) unless node.left.nil?
        values.append(node.data)
        inorder(node.right, values) unless node.right.nil?
        values
    end

    def preorder(node = @root, values = [])
        return nil if node.nil?
    
        values.append(node.data)
        preorder(node.left, values) unless node.left.nil?
        preorder(node.right, values) unless node.right.nil?
        values
    end
    
    def postorder(node = @root, values = [])
        return nil if node.nil?
    
        postorder(node.left, values) unless node.left.nil?
        postorder(node.right, values) unless node.right.nil?
        values.append(node.data)
        values
    end

    def leaf(node)
        node.left.nil? && node.right.nil?
    end
    
    def find_leaves(node, leaf_array = [])
        find_leaves(node.left, leaf_array) unless node.left.nil?
        find_leaves(node.right, leaf_array) unless node.right.nil?
        leaf_array.append(node.data) if leaf(node)
        leaf_array
    end


    #Write a #height method which accepts a node and returns its height. 
    #Height is defined as the number of edges in longest path from a given node to a leaf node.
    def height(value)
        node = find(value)
        return 0 if leaf(node)
    
        leaf_array = find_leaves(node)
        depth_array = []
        leaf_array.each do |leaf|
          depth_array.append(depth(leaf, node))
        end
        depth_array.max
    end


    #Write a #depth method which accepts a node and returns its depth. 
    #Depth is defined as the number of edges in path from a given node to the tree’s root node.
    def depth(value, node = @root, depth = 0)
        return nil if node.nil?
    
        if node.data < value
          depth += 1
          depth(value, node.right, depth)
        elsif node.data > value
          depth += 1
          depth(value, node.left, depth)
        else
          depth
        end
    end

    #Write a #balanced? method which checks if the tree is balanced. 
    #A balanced tree is one where the difference between heights of left 
    #subtree and right subtree of every node is not more than 1.
    def balanced?(node = @root)
        return nil if node.nil?
    
        if node.right.nil?
          return false if height(node.left.data) > 1
    
        elsif node.left.nil?
          return false if height(node.right.data) > 1
    
        elsif (height(node.right.data) - height(node.left.data)).abs > 1
          return false
    
        end
        true
    end


    #Write a #rebalance method which rebalances an unbalanced tree. 
    #Tip: You’ll want to create a level-order array of the tree before 
    #passing the array back into the #build_tree method.
    def rebalance
        rebalance_array = inorder
        print rebalance_array
        puts
        @root = build_tree(rebalance_array, 0, rebalance_array.length - 1)
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
      end

end



tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
puts "True or false, the tree is balanced?: #{tree.balanced?}"
print "Elements in order: #{tree.inorder}"
puts
print "Elements in preorder: #{tree.preorder}"
puts
print "Elements in postorder: #{tree.postorder}"
puts
puts 'I will now add 10 elements greater than 100 in order to unbalance the tree'
10.times { tree.insert(rand(100..500)) }
tree.pretty_print
puts "True or false, the tree is balanced?: #{tree.balanced?}"
puts 'I will now rebalance the tree'
tree.rebalance
tree.pretty_print
puts "True or false, the tree is balanced?: #{tree.balanced?}"
print "Elements in order: #{tree.inorder}"
puts
print "Elements in preorder: #{tree.preorder}"
puts
print "Elements in postorder: #{tree.postorder}"
puts