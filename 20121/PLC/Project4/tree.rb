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
  end

  # DEFINE to_s HERE
  def to_s
    return nil.to_s
  end

  # DEFINE each HERE
  def each 
  end

  # DEFINE tmap HERE
  def tmap
  end

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
  def size
    return 1 + @leftChild.size + @rightChild.size
  end

  # DEFINE height HERE
  def height
    leftHeight = @leftChild.height
    rightHeight = @rightChild.height
    if (leftHeight >= rightHeight)
      return leftHeight + 1
    else
      return rightHeight + 1
    end
  end

  # DEFINE deepest HERE
  def deepest
    if size == 0
      return nil
    elsif (height == 1)
      return @element
    else 
      leftHeight = @leftChild.height
      rightHeight = @rightChild.height

      if (leftHeight == rightHeight)
        return [@leftChild.deepest, @rightChild.deepest]
      elsif (leftHeight > rightHeight)
        return @leftChild.deepest
      else # rightHeight > leftHeight)
        return @rightChild.deepest
      end
    end
  end

  # DEFINE to_s HERE
  def to_s

  end

  # DEFINE each HERE
  def each

  end

  # DEFINE tmap HERE
  def tmap

  end

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
  def size
    sum = 1
    @children.each {|x| sum = sum + x.size}
    return sum
  end

  # DEFINE height HERE
  def height

  end

  # DEFINE deepest HERE
  def deepst

  end

  # DEFINE to_s HERE
  def to_s

  end

  # DEFINE each HERE
  def each

  end

  # DEFINE tmap HERE
  def tmap

  end

end

# DEFINE tree_to_s HERE
def tree_to_s t
  t.to_s
end
