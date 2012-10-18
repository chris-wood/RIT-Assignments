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

  # DEFINE each HERE

  # DEFINE <=> HERE

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
