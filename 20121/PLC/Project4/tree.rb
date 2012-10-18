# Christopher Wood

class Leaf 
  include Enumerable

  # DEFINE initialize HERE
  def initialize

  end

  # DEFINE size HERE
  def size
    return 0
  end

  # DEFINE height HERE
  def height
    return 0
  end

  # DEFINE deepest HERE
  def deepest
    return nil
  end

  # DEFINE to_s HERE
  def to_s
    return nil.to_s
  end

  # DEFINE each HERE
  def each 

  end

  # DEFINE tmap HERE

end

class BinaryNode 
  include Enumerable

  # DEFINE initialize HERE
  def initialize(element, leftChild, rightChild)
    @element = element
    @leftChild = leftChild
    @rightChild = rightChild
  end

  # DEFINE size HERE

  # DEFINE height HERE
  def height
    #leftHeight = @leftChild.height
    #rightHeight = @rightChild.height
    #return # the max of the two
    
  end

  # DEFINE deepest HERE

  # DEFINE to_s HERE

  # DEFINE each HERE

  # DEFINE tmap HERE

end

class NaryNode
  include Enumerable

  # DEFINE initialize HERE
  def initialize(element, children)
    @element = element

    # Build the copy of the children array
    #@children = []
    #children.each {|x| @children << x}
    @children = children.clone()
  end

  # DEFINE size HERE

  # DEFINE height HERE

  # DEFINE deepest HERE

  # DEFINE to_s HERE

  # DEFINE each HERE

  # DEFINE tmap HERE

end

# DEFINE tree_to_s HERE
