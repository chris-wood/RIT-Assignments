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
  def [] index
    return @a[index] # TODO: this is not correct...
  end

  # DEFINE each HERE
  def each &block
    @a.each {|c| c.each &block}
  end

  # DEFINE <=> HERE
  def <=> otherArray
    # Fetch the array lengths
    length1 = @a.length - 1
    length2 = otherArray.length - 1

    val = 0
    for i in 0..length1
      if (i < length2)
        if (@a[i] != otherArray[i])
          return @a[i] <=> otherArray[i]  #TODO: not working correctly
        end
      else
        return val
      end
    end
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

  # DEFINE inspect HERE

  # DEFINE length HERE

  # DEFINE elem_at HERE

end

class RepeatXArray
  include XArray

  # DEFINE initialize HERE

  # DEFINE inspect HERE

  # DEFINE length HERE

  # DEFINE elem_at HERE

end

class ReverseXArray
  include XArray

  # DEFINE initialize HERE

  # DEFINE inspect HERE

  # DEFINE length HERE

  # DEFINE elem_at HERE

end

class PalindromeXArray
  include XArray

  # DEFINE initialize HERE

  # DEFINE inspect HERE

  # DEFINE length HERE

  # DEFINE elem_at HERE

end

class SwizzleXArray
  include XArray

  # DEFINE initialize HERE

  # DEFINE inspect HERE

  # DEFINE length HERE

  # DEFINE elem_at HERE

end

class ProcXArray
  include XArray

  # DEFINE initialize HERE

  # DEFINE inspect HERE

  # DEFINE length HERE

  # DEFINE elem_at HERE

end
