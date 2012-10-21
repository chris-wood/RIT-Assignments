# Christopher Wood

module XArray
  include Comparable
  include Enumerable

  def + s
    ConcatXArray.new(self, s)
  end

  def * n
    RepeatXArray.new(self, n)
  end

  def << obj
    p = lambda {|i| if i == self.length : obj else self[i] end}
    def p.inspect ; "$p_push" end
    def p.to_s ; "$p_push" end
    ProcXArray.new(self.length + 1, p)
  end

  def concat arr
    ConcatXArray.new(self, arr)
  end

  def reverse
    ReverseXArray.new(self)
  end

  # DEFINE [] HERE
  def [] (start, len = nil)
    if (start < 0)
      start = start + self.length
    end
    return nil if (start < 0 || start >= self.length)

    # Check to see what we should return
    if (len == nil)
      return self.elem_at(start)
    else
      # Make sure we don't run past the upper bound
      #return nil if ((start + len - 1) >= self.length)

      # Build the resulting array
      result = []
      for i in start..(start + len - 1)
        if (i >= self.length)
          return result # we reached the end of the array
        else
          result << self.elem_at(i)
        end
      end
      return result
    end
  end

  # DEFINE each HERE
  def each #&block #caw
    #print self.inspect
    for i in 0..(self.length - 1)
      yield self.elem_at(i)
    end
    #self.each {|c| yield c} #c.each &block #caw
    self
  end

  # DEFINE <=> HERE
  def <=> (othr)
    # Fetch the array lengths
    length1 = self.length - 1
    length2 = othr.length - 1

    minVal = [length1, length2].min
    val = 0
    for i in 0..(minVal - 1)
      val = self.elem_at(i) <=> othr.elem_at(i)
      if (val != 0)
        return val
      end
      #if (self.elem_at(i) != othr.elem_at(i))
      #  return self.elem_at(i) <=> othr.elem_at(i)  #TODO: not working correctly
      #end
    end
    return val
  end

end

class ArrXArray
  include XArray

  def initialize(a)
    @a = a.clone
  end

  def inspect
    "ArrXArray(#{@a.inspect})"
  end

  def length
    @a.length
  end

  def elem_at i
    return nil if i < 0 || i >= length
    @a[i]
  end
end

class ConcatXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a1, a2)
    @a1 = a1.clone
    @a2 = a2.clone
    #@a = a1.clone
    #a2.each {|x| @a << x}
  end

  # DEFINE inspect HERE
  def inspect
    #result = ""
    #for i in 0..(@a1.length - 1)
    #  result = result + @a1.elem_at(i).to_s
    #end
    #for i in 0..(@a2.length - 1)
    #  result = result + @a2.elem_at(i).to_s
    #end
    #@a1.each {|x| result = result + x.to_s}
    #@a2.each {|x| result = result + x.to_s}
    result = @a1.inspect + "," + @a2.inspect
    "ConcatXArray(#{result})"
  end

  # DEFINE length HERE
  def length
    @a1.length + @a2.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    if (i < @a1.length)
      #return @a1[i]
      return @a1.elem_at(i)
    else
      #return @a2[i - @a1.length]
      return @a2.elem_at(i - @a1.length)
    end
    #return nil if (i < 0 || i >= length)
    #@a[i]
  end

end

class RepeatXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a, n)
    @a = a.clone
    @n = n
    #for i in 0..(n - 1)
    #  a.each {|x| @a << x}
    #end
  end

  # DEFINE inspect HERE
  def inspect
    #result = ""
    #for i in 0..(@n - 1)
    #  for j in 0..(@a.length - 1)
    #    result = result + @a.elem_at(j).to_s
    #  end
    #  #@a.each {|x| result = result + x.to_s}
    #end
    result = @a.inspect + "," + @n.inspect
    "RepeatXArray(#{result})"
  end

  # DEFINE length HERE
  def length
    @a.length * @n
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @a.elem_at(i % @a.length)
  end

end

class ReverseXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a)
    @a = a.clone
    #@a = []
    #a.each {|x| @a.insert(0, x)}
  end

  # DEFINE inspect HERE
  def inspect
    #result = ""
    #for i in 0..(@a.length - 1)
    #  result = @a.elem_at(i).to_s + result
    #end
    #@a.each {|x| result = x.to_s + result}
    result = @a.inspect
    "ReverseXArray(#{result})"
  end

  # DEFINE length HERE
  def length
    @a.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @a.elem_at(@a.length - (i + 1))
  end

end

class PalindromeXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a)
    @a = a.clone()
    #index = a.length
    #a.each {|x| @a.insert(index, x)}
  end

  # DEFINE inspect HERE
  def inspect
    #firstHalf = ""
    #secondHalf = ""

    #for i in 0..(@a.length - 1)
    #  firstHalf = firstHalf + @a.elem_at(i).to_s
    #end
    #for i in 0..(@a.length - 1)
    #  secondHalf = @a.elem_at(i).to_s + secondHalf
    #end
    #@a.each {|x| firstHalf = firstHalf + x.to_s}
    #@a.each {|x| secondHalf = x.to_s + secondHalf}
    #result = firstHalf + secondHalf
    result = @a.inspect
    "PalindromeXArray(#{result})"
  end

  # DEFINE length HERE
  def length
    @a.length * 2
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    if (i < @a.length)
      return @a.elem_at(i)
    else
      return @a.elem_at(@a.length - ((i % @a.length) + 1))
    end
  end

end

class SwizzleXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a1, a2)
    @a1 = a1.clone
    @a2 = a2.clone

    #a1length = a1.length
    #a2length = a2.length
    #max = [a1length, a2length].max

    #for i in 0..max
    #  if (i < a1length)
    #    @a << a1[i]
    #  end
    #  if (i < a2length)
    #    @a << a2[i]
    #  end
    #end
  end

  # DEFINE inspect HERE
  def inspect
    result = ""

    # Build up the swizzle representation
    #a1length = @a1.length
    #a2length = @a2.length
    #max = [a1length, a2length].max

    #for i in 0..(max - 1)
    #  if (i < a1length)
    #    result = result + @a1.elem_at(i).to_s
    #  end
    #  if (i < a2length)
    #    result = result + @a2.elem_at(i).to_s
    #  end
    #end

    result = @a1.inspect + "," + @a2.inspect

    "SwizzleXArray(#{result})"
  end

  # DEFINE length HERE
  def length
    @a1.length + @a2.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)

    # Determine the minimum length 
    a1length = @a1.length
    a2length = @a2.length
    minLength = [a1length, a2length].min

    if (i < (minLength * 2))
      if (i % 2 == 0) 
        return @a1.elem_at(i / 2)
      else
        return @a2.elem_at((i - 1) / 2)
      end
    elsif (a1length > a2length)
      return @a1.elem_at(i - minLength)
    elsif (a2length > a1length)
      return @a2.elem_at(i - minLength)
    end
  end

end

class ProcXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(n, p)
    @n = n
    @p = p
    #@a = []
    #for i in 0..n
    #  @a << (p.call i)
    #end
  end

  # DEFINE inspect HERE
  def inspect
    #result = ""
    #for i in 0..(@n - 1)
    #  result = result + (@p.call i).to_s
    #end
    result = @n.inspect + "," + @p.inspect
    "ProcXArray(#{result})"
  end

  # DEFINE length HERE
  def length
    @n
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @p.call i
  end

end
