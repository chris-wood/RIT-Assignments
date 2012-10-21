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
      start = start + @a.length
    end
    return nil if (start < 0 || start >= @a.length)

    # Check to see what we should return
    if (len == nil)
      return @a[start]
    else
      # Make sure we don't run past the upper bound
      return nil if (start + len >= @a.length)

      # Build the resulting array
      result = []
      for i in start..(start + len)
        result << @a[i]
      end
      return result
    end
  end

  # DEFINE each HERE
  def each #&block #caw
    @a.each {|c| yield c} #c.each &block #caw
    self
  end

  # DEFINE <=> HERE
  def <=> (othr)
    # Fetch the array lengths
    length1 = @a.length - 1
    length2 = othr.length - 1

    maxVal = [length1, length2].max
    val = 0
    for i in 0..maxVal
      if (@a[i] != othr[i])
        return @a[i] <=> othr[i]  #TODO: not working correctly
      end
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
    @a = a1.clone
    a2.each {|x| @a << x}
  end

  # DEFINE inspect HERE
  def inspect
    "ConcatXArray(#{@a.inspect})"
  end

  # DEFINE length HERE
  def length
    @a.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @a[i]
  end

end

class RepeatXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a, n)
    @a = []
    for i in 0..n
      a.each {|x| @a << x}
    end
  end

  # DEFINE inspect HERE
  def inspect
    "RepeatXArray(#{@a.inspect})"
  end

  # DEFINE length HERE
  def length
    @a.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @a[i]
  end

end

class ReverseXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a)
    @a = []
    a.each {|x| @a.insert(0, x)}
  end

  # DEFINE inspect HERE
  def inspect
    "ReverseXArray(#{@a.inspect})"
  end

  # DEFINE length HERE
  def length
    @a.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @a[i]
  end

end

class PalindromeXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a)
    @a = a.clone()
    index = a.length
    a.each {|x| @a.insert(index, x)}
  end

  # DEFINE inspect HERE
  def inspect
    "PalindromeXArray(#{@a.inspect})"
  end

  # DEFINE length HERE
  def length
    @a.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @a[i]
  end

end

class SwizzleXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a1, a2)
    @a = []
    a1length = a1.length
    a2length = a2.length
    max = [a1length, a2length].max

    for i in 0..max
      if (i < a1length)
        @a << a1[i]
      end
      if (i < a2length)
        @a << a2[i]
      end
    end
  end

  # DEFINE inspect HERE
  def inspect
    "SwizzleXArray(#{@a.inspect})"
  end

  # DEFINE length HERE
  def length
    @a.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @a[i]
  end

end

class ProcXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(n, p)
    @a = []
    for i in 0..n
      @a << (p.call i)
    end
  end

  # DEFINE inspect HERE
  def inspect
    "ProcXArray(#{@a.inspect})"
  end

  # DEFINE length HERE
  def length
    @a.length
  end

  # DEFINE elem_at HERE
  def elem_at i
    return nil if (i < 0 || i >= length)
    @a[i]
  end

end
