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
      # Build the resulting array
      result = []
      for i in start..(start + len - 1)
        return result if i >= self.length # we have reached the end of the array
        result << self.elem_at(i)
      end
      return result
    end
  end

  # DEFINE each HERE
  def each 
    for i in 0..(self.length - 1)
      yield self.elem_at(i)
    end
    self
  end

  # DEFINE <=> HERE
  def <=> (othr)
    # Fetch the array lengths
    length1 = self.length - 1
    length2 = othr.length - 1

    maxVal = [length1, length2].max
    val = 0
    for i in 0..(maxVal - 1)
      if (i < length1 && i < length2)
        val = self.elem_at(i) <=> othr.elem_at(i)
        return val if val != 0
      elsif (i < length1)
        return 1
      else 
        return -1
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
    @a1 = a1.clone
    @a2 = a2.clone
  end

  # DEFINE inspect HERE
  def inspect
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
      return @a1.elem_at(i)
    else
      return @a2.elem_at(i - @a1.length)
    end
  end

end

class RepeatXArray
  include XArray

  # DEFINE initialize HERE
  def initialize(a, n)
    @a = a.clone
    @n = n
  end

  # DEFINE inspect HERE
  def inspect
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
  end

  # DEFINE inspect HERE
  def inspect
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
  end

  # DEFINE inspect HERE
  def inspect
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
  end

  # DEFINE inspect HERE
  def inspect
    result = ""
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
  end

  # DEFINE inspect HERE
  def inspect
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
