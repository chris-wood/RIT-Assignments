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
    h = Hash.new 0

    # Walk both hashes to make sure we get the union of the key sets
    @hash.each {|k,v| h[k] = v + othr.hash[k]}
    othr.hash.each {|k,v| h[k] = @hash[k] + v if not (h.has_key? k)}
    
    return LetterCount.new(h)
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

  # Cache the line buffer
  lineBuffer = []
  file.each_line {|w| lineBuffer << w}
  puts lineBuffer

  # Search for all single lines
  lineBuffer.each {|w|
    w = w.chop
    wlc = LetterCount.new w
    d = lc.difference wlc
    if (d && d.all_zeros) then puts w end
  }

  # Search for all double lines
  n = lineBuffer.length
  for i in 0..(n - 2) # DECIPHER: the same line can be used twice to form an anagram (it just has an impact on the buffer bounds)
    for j in (i + 1)..(n - 1)
      #puts "trying " + i.to_s + " and " + j.to_s
      w1 = lineBuffer[i].chop
      w2 = lineBuffer[j].chop
      puts "trying " + w1.to_s + " and " + w2.to_s

      w1lc = LetterCount.new w1
      w2lc = LetterCount.new w2

      d = lc.difference(w1lc.sum w2lc)

      if (d && d.all_zeros) then puts w end
    end
  end

  # Close the file and return
  file.close
end

# DEFINE anagrams HERE
