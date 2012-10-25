# Christopher Wood

class LetterCount
  attr_reader :hash
  protected :hash

  def initialize arg
    if arg.is_a? String
      @hash = str_to_count arg
    elsif arg.is_a? Hash
      @hash = arg
    else
      raise ArgumentError.new "argument neither String nor Hash"
    end
  end

  def difference othr
    ans = @hash.clone
    othr.hash.each { |letter, value| 
      if value > ans[letter] 
        return nil 
      else 
        ans[letter] -= value
      end
    }
    LetterCount.new ans
  end

  def all_zeros 
    @hash.each { |letter,value| if value != 0 : return false end }
    true
  end

  # DEFINE sum HERE
  def sum othr
    h = @hash.clone
    othr.hash.each {|k,v| h[k] = h[k] + v}
    LetterCount.new(h)
  end
  
  private
  def str_to_count s
    h = Hash.new 0
    s.split("").each { |c| h[c] += 1 }
    h
  end
end

def anagrams1(word,file_name)
  lc = LetterCount.new word
  file = File.new(file_name, "r")
  file.each_line { |w|
    w = w.chop
    wlc = LetterCount.new w
    d = lc.difference wlc
    if d && d.all_zeros then puts w end
  }
  file.close
end

# DEFINE anagrams2 HERE
def anagrams2(word,file_name)
  lc = LetterCount.new word
  file = File.new(file_name, "r")

  # Cache the lines in the file and the corresponding LetterCount objects
  countBuffer = []
  lineBuffer = []
  file.each_line {|w| 
    countBuffer << LetterCount.new(w.chop)
    lineBuffer << w.chop
  }

  # Walk across each line to do the permutation check
  for i in 0..(countBuffer.length - 1)
    d = lc.difference(countBuffer[i])
    if (d && d.all_zeros) then puts lineBuffer[i] end
    if d # short-circuit if we can't possibly make the match
      for j in i..(countBuffer.length - 1)
        d2 = d.difference(countBuffer[j])
        if (d2 && d2.all_zeros) then puts lineBuffer[i] + " " + lineBuffer[j] end
      end
    end
  end

  # Close the file and return
  file.close
end

# DEFINE anagrams HERE
