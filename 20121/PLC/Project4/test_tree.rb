require('tree.rb')

def build_binary_tree n
  if n <= 0
    Leaf.new
  else
    BinaryNode.new(n, build_binary_tree(n-1), build_binary_tree(n-1))
  end
end

def build_nary_tree n
  if n <= 4
    build_binary_tree n
  else
    NaryNode.new(n, (0...n).map {|i| build_nary_tree i})
  end
end

def test_tree n, t
  puts "t#{n}.size       = #{t.size.to_s}"
  puts "t#{n}.height     = #{t.height.to_s}"
  puts "t#{n}.deepest    = #{t.deepest.to_s}"
  puts "t#{n}.to_s       = #{t.to_s}"
  puts "tree_to_s(t#{n}) = #{tree_to_s t}"
  puts "t#{n}.min        = #{t.min}"
  puts "t#{n}.max        = #{t.max}"
  puts ""
end

t1 = Leaf.new
test_tree 1, t1
t2 = BinaryNode.new(1,BinaryNode.new(2,t1,t1),BinaryNode.new(3,t1,t1))
test_tree 2, t2
t3 = build_binary_tree 8
test_tree 3, t3
t4 = build_nary_tree 12
test_tree 4, t4
t5 = NaryNode.new("o",[Leaf.new, NaryNode.new("c",[Leaf.new])])
test_tree 5, t5
t6 = NaryNode.new("t",[NaryNode.new("i",[NaryNode.new("n",[BinaryNode.new("c",Leaf.new,BinaryNode.new("t",Leaf.new,NaryNode.new("y",[Leaf.new, Leaf.new])))]), Leaf.new]), Leaf.new])
test_tree 6, t6
t7 = NaryNode.new("u",[NaryNode.new("b",[Leaf.new, NaryNode.new("b",[Leaf.new, NaryNode.new("a",[Leaf.new, Leaf.new, Leaf.new, BinaryNode.new("b",Leaf.new,Leaf.new)]), NaryNode.new("c",[Leaf.new, Leaf.new, Leaf.new])])]), BinaryNode.new("f",NaryNode.new("n",[NaryNode.new("x",[NaryNode.new("v",[Leaf.new, NaryNode.new("j",[NaryNode.new("c",[NaryNode.new("h",[BinaryNode.new("s",Leaf.new,Leaf.new), BinaryNode.new("x",BinaryNode.new("p",NaryNode.new("n",[Leaf.new, Leaf.new]),Leaf.new),Leaf.new), Leaf.new, Leaf.new]), BinaryNode.new("u",NaryNode.new("d",[Leaf.new]),Leaf.new), Leaf.new, Leaf.new]), Leaf.new, BinaryNode.new("r",BinaryNode.new("i",Leaf.new,Leaf.new),BinaryNode.new("w",Leaf.new,NaryNode.new("z",[NaryNode.new("z",[Leaf.new, Leaf.new])])))]), BinaryNode.new("a",Leaf.new,NaryNode.new("e",[NaryNode.new("k",[Leaf.new, Leaf.new]), NaryNode.new("o",[Leaf.new, Leaf.new]), Leaf.new])), NaryNode.new("p",[NaryNode.new("o",[Leaf.new, Leaf.new, Leaf.new]), Leaf.new, Leaf.new, NaryNode.new("h",[Leaf.new, Leaf.new])])]), Leaf.new, BinaryNode.new("u",Leaf.new,BinaryNode.new("q",BinaryNode.new("r",Leaf.new,NaryNode.new("z",[Leaf.new, Leaf.new, Leaf.new, NaryNode.new("w",[Leaf.new, Leaf.new, Leaf.new, Leaf.new])])),Leaf.new))]), BinaryNode.new("k",Leaf.new,Leaf.new), Leaf.new, NaryNode.new("s",[Leaf.new, Leaf.new])]),Leaf.new), NaryNode.new("n",[NaryNode.new("q",[NaryNode.new("r",[Leaf.new, Leaf.new, Leaf.new, NaryNode.new("q",[NaryNode.new("a",[Leaf.new]), Leaf.new])]), NaryNode.new("u",[NaryNode.new("i",[Leaf.new, Leaf.new, Leaf.new, NaryNode.new("c",[BinaryNode.new("f",BinaryNode.new("h",Leaf.new,Leaf.new),BinaryNode.new("q",Leaf.new,NaryNode.new("h",[Leaf.new, Leaf.new]))), Leaf.new, Leaf.new])])])])])])
test_tree 7, t7
t8 = NaryNode.new("w",[NaryNode.new("i",[NaryNode.new("k",[NaryNode.new("f",[BinaryNode.new("n",BinaryNode.new("w",Leaf.new,BinaryNode.new("c",NaryNode.new("j",[Leaf.new, Leaf.new, BinaryNode.new("z",Leaf.new,Leaf.new)]),Leaf.new)),BinaryNode.new("f",Leaf.new,Leaf.new)), Leaf.new])]), BinaryNode.new("a",NaryNode.new("j",[Leaf.new]),NaryNode.new("w",[BinaryNode.new("e",NaryNode.new("o",[Leaf.new, NaryNode.new("h",[Leaf.new, NaryNode.new("c",[Leaf.new, Leaf.new, Leaf.new]), Leaf.new]), Leaf.new]),BinaryNode.new("n",NaryNode.new("g",[Leaf.new, Leaf.new, Leaf.new]),Leaf.new)), Leaf.new, Leaf.new]))]), NaryNode.new("j",[NaryNode.new("x",[NaryNode.new("x",[Leaf.new, Leaf.new]), NaryNode.new("t",[Leaf.new, Leaf.new, Leaf.new, Leaf.new]), NaryNode.new("i",[NaryNode.new("m",[BinaryNode.new("q",Leaf.new,Leaf.new), Leaf.new, Leaf.new]), Leaf.new])]), BinaryNode.new("r",NaryNode.new("j",[Leaf.new, BinaryNode.new("f",Leaf.new,BinaryNode.new("d",Leaf.new,Leaf.new)), Leaf.new]),NaryNode.new("l",[NaryNode.new("i",[Leaf.new, Leaf.new, Leaf.new]), Leaf.new]))])])
test_tree 8, t8
t9 = NaryNode.new("p",[NaryNode.new("r",[NaryNode.new("e",[NaryNode.new("i",[Leaf.new, Leaf.new, NaryNode.new("s",[NaryNode.new("d",[Leaf.new, NaryNode.new("o",[NaryNode.new("g",[Leaf.new, Leaf.new, Leaf.new]), Leaf.new, Leaf.new, Leaf.new]), Leaf.new]), Leaf.new, Leaf.new, Leaf.new]), NaryNode.new("p",[Leaf.new])]), BinaryNode.new("o",Leaf.new,Leaf.new)]), NaryNode.new("j",[Leaf.new, NaryNode.new("q",[Leaf.new, Leaf.new, NaryNode.new("v",[Leaf.new, BinaryNode.new("w",Leaf.new,NaryNode.new("b",[Leaf.new]))])])]), NaryNode.new("m",[Leaf.new, NaryNode.new("p",[Leaf.new, Leaf.new]), NaryNode.new("c",[Leaf.new, Leaf.new, BinaryNode.new("b",Leaf.new,Leaf.new), Leaf.new])])]), NaryNode.new("b",[Leaf.new])])
test_tree 9, t9

# Uncomment these to test the 'tmap' method.
=begin
t1x = t1.tmap {|z| z * 2}
test_tree "1x", t1x
t2x = t2.tmap {|z| z * 2}
test_tree "2x", t2x
t3x = t3.tmap {|z| z.to_s(16)}
test_tree "3x", t3x
t4x = t4.tmap {|z| z.to_s(16)}
test_tree "4x", t4x
t5x = t5.tmap {|z| z.succ}
test_tree "5x", t5x
t6x = t6.tmap {|z| z.succ}
test_tree "6x", t6x
t7x = t7.tmap {|z| z.succ}
test_tree "7x", t7x
t8x = t8.tmap {|z| z.swapcase}
test_tree "8x", t8x
t9x = t9.tmap {|z| z.swapcase}
test_tree "9x", t9x
=end
