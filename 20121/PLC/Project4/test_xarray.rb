require('xarray.rb')

$p1 = lambda {|i| "" << (97 + ((i) % 26))}
def $p1.inspect
  "$p1"
end
def $p1.to_s
  "$p1"
end
$p2 = lambda {|i| "" << (97 + ((i * i) % 26))}
def $p2.inspect
  "$p2"
end
def $p2.to_s
  "$p2"
end
$p3 = lambda {|i| "" << (97 + ((i * i * i) % 26))}
def $p3.inspect
  "$p3"
end
def $p3.to_s
  "$p3"
end

def test_xarray n, xa
  puts "xa#{n}.inspect = #{xa.inspect}"
  puts "xa#{n}.length = #{xa.length.to_s}"
  puts "xa#{n}.elem_at(-1) = #{xa.elem_at(-1)}"
  puts "xa#{n}.elem_at(0) = #{xa.elem_at(0)}"
  (0..32).each {|i| puts "xa#{n}.elem_at(#{2**i}) = #{xa.elem_at(2**i)}" }
  ## puts "xa#{n}.elem_at(2**1024) = #{xa.elem_at(2**1024)}"
  if xa.length < 2**18
    puts "xa#{n}.min = #{xa.min}"
    puts "xa#{n}.max = #{xa.max}"
    puts "xa#{n}.sort = #{xa.sort}"
    ("a".."z").each {|z| puts "xa#{n}.member?(#{z}) = #{xa.member?(z)}" }
  end
  puts "xa#{n}[104] = #{xa[104]}"
  puts "xa#{n}[29] = #{xa[29]}"
  puts "xa#{n}[16] = #{xa[16]}"
  puts "xa#{n}[112] = #{xa[112]}"
  puts "xa#{n}[61] = #{xa[61]}"
  puts "xa#{n}[83] = #{xa[83]}"
  puts "xa#{n}[111] = #{xa[111]}"
  puts "xa#{n}[88] = #{xa[88]}"
  puts "xa#{n}[85] = #{xa[85]}"
  puts "xa#{n}[12] = #{xa[12]}"
  puts "xa#{n}[58] = #{xa[58]}"
  puts "xa#{n}[18] = #{xa[18]}"
  puts "xa#{n}[48] = #{xa[48]}"
  puts "xa#{n}[99] = #{xa[99]}"
  puts "xa#{n}[11] = #{xa[11]}"
  puts "xa#{n}[60] = #{xa[60]}"
  puts "xa#{n}[-104] = #{xa[-104]}"
  puts "xa#{n}[-18] = #{xa[-18]}"
  puts "xa#{n}[-75] = #{xa[-75]}"
  puts "xa#{n}[-8] = #{xa[-8]}"
  puts "xa#{n}[-70] = #{xa[-70]}"
  puts "xa#{n}[-27] = #{xa[-27]}"
  puts "xa#{n}[-77] = #{xa[-77]}"
  puts "xa#{n}[-94] = #{xa[-94]}"
  puts "xa#{n}[-127] = #{xa[-127]}"
  puts "xa#{n}[-51] = #{xa[-51]}"
  puts "xa#{n}[-82] = #{xa[-82]}"
  puts "xa#{n}[-121] = #{xa[-121]}"
  puts "xa#{n}[-110] = #{xa[-110]}"
  puts "xa#{n}[-15] = #{xa[-15]}"
  puts "xa#{n}[-116] = #{xa[-116]}"
  puts "xa#{n}[-68] = #{xa[-68]}"
  puts "xa#{n}[98,11] = #{xa[98,11]}"
  puts "xa#{n}[24,19] = #{xa[24,19]}"
  puts "xa#{n}[122,20] = #{xa[122,20]}"
  puts "xa#{n}[99,20] = #{xa[99,20]}"
  puts "xa#{n}[22,15] = #{xa[22,15]}"
  puts "xa#{n}[56,6] = #{xa[56,6]}"
  puts "xa#{n}[108,20] = #{xa[108,20]}"
  puts "xa#{n}[41,25] = #{xa[41,25]}"
  puts "xa#{n}[38,13] = #{xa[38,13]}"
  puts "xa#{n}[94,25] = #{xa[94,25]}"
  puts "xa#{n}[4,2] = #{xa[4,2]}"
  puts "xa#{n}[86,28] = #{xa[86,28]}"
  puts "xa#{n}[106,10] = #{xa[106,10]}"
  puts "xa#{n}[17,14] = #{xa[17,14]}"
  puts "xa#{n}[75,8] = #{xa[75,8]}"
  puts "xa#{n}[73,25] = #{xa[73,25]}"
  puts "xa#{n}[-107,16] = #{xa[-107,16]}"
  puts "xa#{n}[-124,5] = #{xa[-124,5]}"
  puts "xa#{n}[-6,13] = #{xa[-6,13]}"
  puts "xa#{n}[-12,7] = #{xa[-12,7]}"
  puts "xa#{n}[-41,8] = #{xa[-41,8]}"
  puts "xa#{n}[-49,26] = #{xa[-49,26]}"
  puts "xa#{n}[-121,1] = #{xa[-121,1]}"
  puts "xa#{n}[-4,28] = #{xa[-4,28]}"
  puts "xa#{n}[-36,5] = #{xa[-36,5]}"
  puts "xa#{n}[-82,7] = #{xa[-82,7]}"
  puts "xa#{n}[-111,12] = #{xa[-111,12]}"
  puts "xa#{n}[-64,21] = #{xa[-64,21]}"
  puts "xa#{n}[-115,16] = #{xa[-115,16]}"
  puts "xa#{n}[-126,6] = #{xa[-126,6]}"
  puts "xa#{n}[-88,12] = #{xa[-88,12]}"
  puts "xa#{n}[-3,3] = #{xa[-3,3]}"
  puts ""
end

xa1 = RepeatXArray.new(ArrXArray.new(["a","b","c"]), 2)
xa2 = RepeatXArray.new(ArrXArray.new(["x","y"]), 1_000_000_000_000)
xa3 = SwizzleXArray.new(ProcXArray.new(7,$p1),ReverseXArray.new(SwizzleXArray.new(ArrXArray.new(["a", "a", "s", "k"]),ConcatXArray.new(ReverseXArray.new(ArrXArray.new(["a"])),RepeatXArray.new(RepeatXArray.new(ReverseXArray.new(ReverseXArray.new(ReverseXArray.new(ReverseXArray.new(PalindromeXArray.new(ArrXArray.new(["s", "r", "c", "w", "q"])))))),880729),549639)))))
xa4 = RepeatXArray.new(ArrXArray.new(["i", "g", "d"]),827)
#xa5 = ProcXArray.new(1,$p2)
xa6 = ReverseXArray.new(ReverseXArray.new(ArrXArray.new(["u"])))
xa7 = PalindromeXArray.new(ArrXArray.new(["q", "g"]))
xa8 = ConcatXArray.new(ReverseXArray.new(SwizzleXArray.new(ReverseXArray.new(ArrXArray.new(["q"])),SwizzleXArray.new(ProcXArray.new(15,$p1),ProcXArray.new(12,$p3)))),SwizzleXArray.new(SwizzleXArray.new(ArrXArray.new(["i", "s", "l", "i"]),ConcatXArray.new(PalindromeXArray.new(ProcXArray.new(2,$p1)),PalindromeXArray.new(PalindromeXArray.new(ProcXArray.new(4,$p2))))),ArrXArray.new(["y", "t", "u", "d"])))
#xa9 = ProcXArray.new(6,$p2)
xa10 = PalindromeXArray.new(ConcatXArray.new(ReverseXArray.new(ProcXArray.new(9,$p2)),ConcatXArray.new(PalindromeXArray.new(ConcatXArray.new(ArrXArray.new(["k", "k", "r", "o", "l", "i", "j"]),ReverseXArray.new(SwizzleXArray.new(ConcatXArray.new(ConcatXArray.new(PalindromeXArray.new(ReverseXArray.new(RepeatXArray.new(RepeatXArray.new(RepeatXArray.new(SwizzleXArray.new(ArrXArray.new(["e", "f", "s", "h", "p"]),ReverseXArray.new(ArrXArray.new(["t", "q", "g", "y", "m", "d"]))),517923),166981),744699))),SwizzleXArray.new(ReverseXArray.new(ProcXArray.new(6,$p3)),RepeatXArray.new(SwizzleXArray.new(ConcatXArray.new(ArrXArray.new(["m", "r", "z", "t", "h"]),RepeatXArray.new(ConcatXArray.new(ArrXArray.new(["m", "y", "q"]),ArrXArray.new(["u", "f", "z", "l", "m", "m"])),821052)),PalindromeXArray.new(ProcXArray.new(15,$p2))),486261))),ProcXArray.new(10,$p2)),ConcatXArray.new(ArrXArray.new(["s", "t", "y"]),SwizzleXArray.new(PalindromeXArray.new(RepeatXArray.new(SwizzleXArray.new(PalindromeXArray.new(PalindromeXArray.new(ArrXArray.new(["v", "v", "c", "p", "w"]))),ReverseXArray.new(ReverseXArray.new(RepeatXArray.new(PalindromeXArray.new(RepeatXArray.new(ConcatXArray.new(ReverseXArray.new(ProcXArray.new(7,$p2)),ArrXArray.new(["h", "z"])),630075)),687281)))),295451)),ConcatXArray.new(RepeatXArray.new(ArrXArray.new(["v", "q", "i", "a", "u", "t", "m", "p"]),82844),ReverseXArray.new(PalindromeXArray.new(ArrXArray.new(["f", "r", "s", "e", "o"])))))))))),ArrXArray.new(["x", "r"]))))
xa15 = ReverseXArray.new(ConcatXArray.new(ArrXArray.new(["a", "r", "o", "q", "k", "u"]),ProcXArray.new(10,$p3)))
xa16 = SwizzleXArray.new(ReverseXArray.new(ArrXArray.new(["i", "c"])),ArrXArray.new(["p", "w", "f", "q", "e"]))
xa17 = ConcatXArray.new(ConcatXArray.new(ArrXArray.new(["w", "e", "u", "e", "j"]),RepeatXArray.new(SwizzleXArray.new(SwizzleXArray.new(ProcXArray.new(13,$p2),RepeatXArray.new(PalindromeXArray.new(ArrXArray.new(["m", "m", "d"])),546237)),ArrXArray.new(["h"])),894751)),ArrXArray.new(["h", "g", "z", "z"]))
xa11 = ReverseXArray.new(ConcatXArray.new(SwizzleXArray.new(PalindromeXArray.new(PalindromeXArray.new(PalindromeXArray.new(ConcatXArray.new(ProcXArray.new(13,$p2),ArrXArray.new(["s", "g", "f"]))))),ArrXArray.new(["r", "b", "r", "o", "s", "b"])),ProcXArray.new(8,$p1)))
xa12 = PalindromeXArray.new(PalindromeXArray.new(ReverseXArray.new(ConcatXArray.new(RepeatXArray.new(PalindromeXArray.new(ConcatXArray.new(ProcXArray.new(12,$p1),RepeatXArray.new(SwizzleXArray.new(ArrXArray.new(["k", "q", "v", "m", "f"]),SwizzleXArray.new(ReverseXArray.new(SwizzleXArray.new(ProcXArray.new(2,$p2),RepeatXArray.new(ArrXArray.new(["z", "s", "e", "e", "t", "q"]),523156))),RepeatXArray.new(ConcatXArray.new(ArrXArray.new(["z", "d", "g", "g", "r", "c"]),ArrXArray.new(["y", "d", "f", "i", "v", "n", "l", "y"])),663070))),67155))),931479),ArrXArray.new(["x", "l", "j", "v", "g"])))))
xa13 = xa3 + xa4 + xa5
xa14 = xa6 * 1024
xa15 = xa7 << "m" << "a" << "t" << "t" << "h" << "e" << "w"
xa16 = xa8.reverse
xa17 = xa9.reverse.reverse
xa18 = RepeatXArray.new(RepeatXArray.new(xa5,1024),0)
xa19 = ConcatXArray.new(ProcXArray.new(13,$p3),RepeatXArray.new(RepeatXArray.new(ProcXArray.new(0,$p3),1),1))

test_xarray 1, xa1
test_xarray 2, xa2
test_xarray 3, xa3
test_xarray 4, xa4
test_xarray 5, xa5
test_xarray 6, xa6
test_xarray 7, xa7
test_xarray 8, xa8
test_xarray 9, xa9
test_xarray 10, xa10
test_xarray 11, xa11
test_xarray 12, xa12
test_xarray 13, xa13
test_xarray 14, xa14
test_xarray 15, xa15
test_xarray 16, xa16
test_xarray 17, xa17
test_xarray 18, xa18
test_xarray 19, xa19

xa20 = ArrXArray.new(["y", "m", "a", "q", "m", "d"])
xa21 = SwizzleXArray.new(PalindromeXArray.new(SwizzleXArray.new(PalindromeXArray.new(PalindromeXArray.new(SwizzleXArray.new(ProcXArray.new(1,$p1),PalindromeXArray.new(ArrXArray.new(["k", "o", "l", "h", "v", "t", "f"]))))),ArrXArray.new(["x", "z", "m", "m"]))),ArrXArray.new(["q", "f", "b", "d", "v"]))
xa22 = ArrXArray.new(["s", "l", "g", "i", "f"])
xa23 = SwizzleXArray.new(PalindromeXArray.new(ArrXArray.new(["z", "d", "j", "e", "u"])),ProcXArray.new(13,$p3))
xa24 = RepeatXArray.new(ReverseXArray.new(RepeatXArray.new(ReverseXArray.new(ReverseXArray.new(ProcXArray.new(15,$p3))),7)),7)
xa25 = RepeatXArray.new(ReverseXArray.new(ArrXArray.new(["l", "j", "l", "k", "o", "p"])),0)
xa26 = ArrXArray.new(["l", "s"])
xa27 = SwizzleXArray.new(SwizzleXArray.new(ConcatXArray.new(PalindromeXArray.new(ArrXArray.new(["c", "a", "m", "u", "z", "n"])),ReverseXArray.new(ArrXArray.new(["v", "j", "g", "u", "o", "o", "d"]))),ConcatXArray.new(ProcXArray.new(9,$p1),ConcatXArray.new(ProcXArray.new(11,$p1),ArrXArray.new(["h", "a", "e", "v"])))),ConcatXArray.new(ProcXArray.new(15,$p2),ArrXArray.new(["e", "x", "n", "r", "p", "f", "y"])))
xa28 = PalindromeXArray.new(RepeatXArray.new(ConcatXArray.new(RepeatXArray.new(ReverseXArray.new(ConcatXArray.new(SwizzleXArray.new(ArrXArray.new(["k", "a", "v", "f", "p", "t", "l", "k"]),RepeatXArray.new(ArrXArray.new(["c", "o", "p", "m", "q"]),2)),ProcXArray.new(10,$p1))),2),ProcXArray.new(2,$p2)),5))
xa29 = ReverseXArray.new(PalindromeXArray.new(ProcXArray.new(2,$p2)))
xa30 = ProcXArray.new(5,$p3)
xa31 = PalindromeXArray.new(SwizzleXArray.new(SwizzleXArray.new(ArrXArray.new(["w", "o", "k", "z", "c", "c", "p", "e"]),ProcXArray.new(12,$p2)),RepeatXArray.new(SwizzleXArray.new(ArrXArray.new(["s", "k", "b", "j", "k"]),ProcXArray.new(15,$p1)),2)))
xa32 = ReverseXArray.new(PalindromeXArray.new(ArrXArray.new(["e", "e", "s", "u", "l", "r", "d"])))
xa33 = ProcXArray.new(0,$p3)
xa34 = RepeatXArray.new(ProcXArray.new(5,$p1),0)
xa35 = PalindromeXArray.new(ReverseXArray.new(ReverseXArray.new(SwizzleXArray.new(ProcXArray.new(1,$p3),ReverseXArray.new(ProcXArray.new(11,$p2))))))

test_xarray 20, xa20
test_xarray 21, xa21
test_xarray 22, xa22
test_xarray 23, xa23
test_xarray 24, xa24
test_xarray 25, xa25
test_xarray 26, xa26
test_xarray 27, xa27
test_xarray 28, xa28
test_xarray 29, xa29
test_xarray 30, xa30
test_xarray 31, xa31
test_xarray 32, xa32
test_xarray 33, xa33
test_xarray 34, xa34
test_xarray 35, xa35

xas = [xa20,xa21,xa22,xa23,xa24,xa25,xa26,xa27,xa28,xa29,xa30,xa31,xa32,xa33,xa34,xa35]
xas.each_index {|i|
  xas.each_index {|j|
    puts "xa#{i+20} <=> xa#{j+20} = #{xas[i] <=> xas[j]}"
  }
}
puts ""
puts "[xa20,xa21,xa22,xa23,xa24,xa25,xa26,xa27].min = #{[xa20,xa21,xa22,xa23,xa24,xa25,xa26,xa27].min.inspect}"
puts "[xa20,xa21,xa22,xa23,xa24,xa25,xa26,xa27].max = #{[xa20,xa21,xa22,xa23,xa24,xa25,xa26,xa27].max.inspect}"
puts "[xa28,xa29,xa30,xa31,xa32,xa33,xa34,xa35].min = #{[xa28,xa29,xa30,xa31,xa32,xa33,xa34,xa35].min.inspect}"
puts "[xa28,xa29,xa30,xa31,xa32,xa33,xa34,xa35].max = #{[xa28,xa29,xa30,xa31,xa32,xa33,xa34,xa35].max.inspect}"
