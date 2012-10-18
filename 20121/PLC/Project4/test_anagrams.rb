require('anagrams.rb')

def test_anagrams2 s
  puts "anagrams2(\"#{s}\",\"words\")"
  anagrams2(s, "words")
  puts ""
end

def test_anagrams s
  puts "anagrams(\"#{s}\",\"words\")"
  anagrams(s, "words")
  puts ""
end

test_anagrams2 "matthew"
test_anagrams2 "rochester"
test_anagrams2 "proglangs"
test_anagrams2 "programming"

test_anagrams "matthew"
test_anagrams "rochester"
test_anagrams "proglangs"
