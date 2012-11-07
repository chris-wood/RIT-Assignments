(* Christopher Wood *)

(* Binary tree datatype. *)
datatype 'a btree = Leaf | Node of 'a btree * 'a * 'a btree

(* A reduction function. *)
(* btree_reduce : ('b * 'a * 'b -> 'b) -> 'b -> 'a tree -> 'b) *)
fun btree_reduce f b bt =
   case bt of
      Leaf => b
    | Node (l, x, r) => f (btree_reduce f b l, x, btree_reduce f b r)


(* DEFINE btree_size HERE *)
(* btree_size : 'a btree -> int *)
fun btree_size bt = btree_reduce (fn (l, x, r) => 1 + l + r) 0 bt


(* DEFINE btree_height HERE *)
(* btree_height : 'a btree -> int *)
fun btree_height bt = btree_reduce (fn (l, x, r) => 1 + Int.max(l, r)) 0 bt


(* DEFINE btree_deepest HERE *)
(* btree_deepest : 'a btree -> 'a list *)
fun btree_deepest bt =
	let 
		(* Return the deepest element list and its depth for the current node *)
		fun nodeDeepest (l, x, r) = 
			(case (l, r) of 
				(([], 0), ([], 0)) => ([x], 1) (* leaves on both sides, so we're the deepest *)
				| ((l1, d1), (r1, d2)) =>
					if d1 = d2 then 
						(l1 @ r1, d1 + 1)
					else if d1 > d2 then
						(l1, d1 + 1)
					else
						(r1, d2 + 1))
	in
		(fn (l, h) => l)  (btree_reduce nodeDeepest ([], 0) bt)
	end


(* DEFINE btree_max HERE *)
(* btree_max : ('a * 'a -> order) -> 'a btree -> 'a option *)
fun btree_max comp bt = 
	let
		(* Choose the maximum value from a pair *)
		fun pickMax (leftMax, rightMax) = 
			(case (leftMax, rightMax) of 
				(SOME l, SOME r) =>
					(case comp (l, r) of 
						LESS => SOME r
						| EQUAL => SOME r
						| GREATER => SOME l)
				| (SOME l, NONE) => SOME l
				| (NONE, SOME r) => SOME r
				| (NONE, NONE) => NONE)
	in
		btree_reduce (fn (l, x, r) => pickMax (SOME x, pickMax (l, r))) NONE bt
	end


;

local
(* Testing functions *)
fun run_test f check test =
   let
      val (test_name, test_input, test_output) = test
   in
      (if check (f test_input, test_output)
          then print (concat ["Test ", test_name, " passed.\n"])
          else print (concat ["Test ", test_name, " failed.\n"]))
      handle exn => print (concat ["Tets ", test_name, " errored. [", exnMessage exn, "]\n"])
   end 
fun run_tests f check tests = app (run_test f check) tests
fun string_equal (s1: string, s2: string) = s1 = s2
fun int_equal (i1: int, i2: int) = i1 = i2
fun option_equal elem_equal = fn (NONE, NONE) => true
                               | (SOME x1, SOME x2) => elem_equal (x1, x2)
                               | _ => false
fun list_equal elem_equal = fn ([],[]) => true
                             | (h1::t1, h2::t2) => elem_equal (h1, h2) andalso list_equal elem_equal (t1, t2)
                             | _ => false

val _ = print "Running tests...\n"


(* Test binary trees *)
val bt01 = Node (Node (Leaf, "em", Leaf), "og", Node (Node (Leaf, "iq", Node (Leaf, "tc", Leaf)), "po", Node (Leaf, "pn", Node (Node (Leaf, "ma", Node (Leaf, "yg", Leaf)), "re", Leaf))))
val bt02 = Leaf
val bt03 = Node (Leaf, "nk", Node (Node (Node (Node (Leaf, "yp", Leaf), "rn", Leaf), "xq", Leaf), "ny", Leaf))
val bt04 = Node (Leaf, "mx", Leaf)
val bt05 = Node (Leaf, "ta", Node (Node (Node (Leaf, "wy", Leaf), "db", Leaf), "at", Node (Leaf, "bx", Node (Node (Node (Node (Node (Node (Leaf, "fw", Leaf), "mq", Leaf), "de", Node (Node (Node (Leaf, "mb", Node (Leaf, "dp", Leaf)), "xh", Node (Node (Leaf, "vi", Leaf), "mt", Node (Leaf, "np", Leaf))), "dh", Leaf)), "rv", Node (Leaf, "he", Node (Node (Node (Node (Node (Node (Leaf, "ip", Leaf), "co", Leaf), "xo", Leaf), "vm", Leaf), "ka", Leaf), "hv", Leaf))), "bp", Node (Leaf, "sz", Leaf)), "qs", Node (Leaf, "wd", Leaf)))))
val bt06 = Node (Leaf, "fi", Node (Node (Leaf, "ac", Node (Node (Node (Leaf, "dj", Leaf), "nj", Leaf), "vh", Leaf)), "gi", Leaf))
val bt07 = Node (Node (Leaf, "tp", Node (Leaf, "pt", Node (Leaf, "ad", Node (Leaf, "lv", Node (Node (Node (Leaf, "lf", Node (Node (Leaf, "ih", Node (Leaf, "tz", Node (Node (Node (Leaf, "yc", Leaf), "jo", Leaf), "xd", Node (Leaf, "ud", Leaf)))), "ue", Leaf)), "zh", Node (Node (Leaf, "sj", Leaf), "bp", Node (Node (Node (Node (Node (Leaf, "me", Node (Node (Leaf, "ma", Leaf), "nn", Node (Leaf, "ui", Node (Leaf, "ib", Node (Leaf, "qc", Leaf))))), "gd", Node (Node (Leaf, "bm", Leaf), "bm", Leaf)), "ux", Leaf), "fn", Node (Leaf, "ys", Node (Node (Leaf, "nh", Leaf), "le", Node (Node (Leaf, "iz", Leaf), "zn", Leaf)))), "cp", Leaf))), "vp", Leaf))))), "vo", Node (Node (Leaf, "io", Leaf), "va", Leaf))
val bt08 = Node (Node (Node (Node (Leaf, "bn", Leaf), "pc", Leaf), "jk", Leaf), "aw", Node (Node (Leaf, "wz", Node (Leaf, "jn", Node (Node (Node (Node (Leaf, "lr", Leaf), "ih", Leaf), "io", Leaf), "nn", Node (Leaf, "us", Leaf)))), "sf", Node (Node (Leaf, "dv", Leaf), "nd", Node (Leaf, "lt", Node (Node (Leaf, "wf", Node (Node (Node (Leaf, "rv", Node (Leaf, "mf", Node (Node (Node (Leaf, "qk", Node (Node (Node (Leaf, "zh", Leaf), "jj", Leaf), "jk", Leaf)), "nf", Leaf), "ty", Leaf))), "bi", Leaf), "oh", Leaf)), "mj", Node (Leaf, "on", Node (Leaf, "cy", Leaf)))))))
val bt09 = Node (Leaf, "hi", Node (Node (Node (Node (Leaf, "zv", Leaf), "at", Leaf), "fn", Leaf), "ox", Node (Node (Node (Node (Leaf, "eu", Leaf), "lk", Leaf), "ak", Node (Node (Leaf, "ho", Node (Leaf, "uf", Leaf)), "am", Node (Leaf, "uu", Leaf))), "yx", Leaf)))
val bt10 = Node (Leaf, "vy", Node (Node (Leaf, "eo", Leaf), "ee", Leaf))
val bt11 = Node (Node (Leaf, "sp", Leaf), "kq", Node (Node (Leaf, "ue", Node (Node (Node (Node (Leaf, "ck", Node (Node (Node (Leaf, "rx", Leaf), "io", Leaf), "dp", Node (Node (Node (Node (Leaf, "tn", Leaf), "jy", Leaf), "zi", Leaf), "oz", Node (Leaf, "ub", Leaf)))), "kx", Leaf), "mo", Leaf), "lq", Leaf)), "fn", Leaf))
val bt12 = Node (Node (Node (Node (Leaf, "tn", Node (Leaf, "qy", Node (Node (Node (Node (Leaf, "sy", Leaf), "or", Node (Leaf, "lk", Leaf)), "kt", Leaf), "ou", Node (Leaf, "nn", Leaf)))), "jx", Leaf), "xj", Leaf), "uz", Node (Node (Node (Leaf, "qs", Node (Leaf, "ur", Node (Node (Node (Leaf, "tz", Leaf), "ig", Node (Leaf, "lt", Leaf)), "tz", Node (Leaf, "cc", Node (Node (Leaf, "lf", Node (Node (Leaf, "lh", Leaf), "ls", Node (Node (Leaf, "cw", Leaf), "kc", Leaf))), "og", Leaf))))), "hn", Leaf), "ss", Node (Node (Node (Leaf, "vx", Leaf), "zy", Node (Node (Node (Leaf, "kb", Leaf), "ug", Leaf), "hc", Node (Leaf, "uh", Leaf))), "rd", Node (Node (Node (Leaf, "nn", Node (Node (Leaf, "xf", Leaf), "ri", Node (Leaf, "zt", Leaf))), "mx", Leaf), "bj", Node (Node (Node (Node (Leaf, "cq", Leaf), "ax", Leaf), "ki", Leaf), "qm", Leaf)))))
val bt13 = Node (Node (Node (Leaf, "hb", Leaf), "zc", Node (Leaf, "fk", Leaf)), "ll", Node (Node (Node (Node (Leaf, "pq", Leaf), "ez", Node (Node (Leaf, "vt", Leaf), "no", Node (Node (Node (Node (Node (Node (Leaf, "qk", Leaf), "ef", Node (Node (Leaf, "ja", Leaf), "na", Leaf)), "my", Node (Leaf, "di", Node (Node (Leaf, "ne", Leaf), "oc", Node (Leaf, "jy", Leaf)))), "cd", Leaf), "nq", Node (Leaf, "ou", Node (Node (Node (Node (Leaf, "oh", Node (Node (Node (Leaf, "mz", Node (Leaf, "xo", Leaf)), "iw", Leaf), "cv", Node (Node (Node (Node (Leaf, "cl", Node (Leaf, "si", Leaf)), "zp", Leaf), "ew", Leaf), "th", Node (Node (Node (Node (Node (Node (Leaf, "wa", Node (Leaf, "tn", Node (Node (Leaf, "ag", Leaf), "gf", Leaf))), "vy", Leaf), "he", Leaf), "rj", Node (Node (Leaf, "uq", Leaf), "dz", Node (Leaf, "rp", Leaf))), "qj", Node (Node (Node (Leaf, "wb", Leaf), "ct", Leaf), "ey", Leaf)), "qm", Node (Leaf, "ks", Leaf))))), "rp", Leaf), "qd", Leaf), "ay", Node (Leaf, "eu", Leaf)))), "hp", Node (Leaf, "qx", Leaf)))), "an", Node (Leaf, "xe", Leaf)), "ig", Leaf))
val bt14 = Node (Node (Node (Node (Leaf, "xz", Node (Leaf, "mr", Leaf)), "ab", Node (Node (Node (Node (Leaf, "pq", Leaf), "ba", Node (Node (Node (Node (Leaf, "un", Leaf), "ll", Leaf), "kh", Leaf), "cb", Node (Node (Leaf, "eu", Node (Leaf, "tv", Node (Leaf, "bf", Node (Leaf, "rt", Leaf)))), "se", Node (Leaf, "im", Node (Leaf, "dd", Leaf))))), "uo", Node (Node (Node (Leaf, "lr", Node (Leaf, "av", Node (Node (Leaf, "sy", Node (Leaf, "ez", Leaf)), "bg", Leaf))), "ph", Leaf), "rn", Leaf)), "xp", Leaf)), "du", Node (Node (Node (Node (Leaf, "gg", Leaf), "hk", Node (Leaf, "xb", Node (Node (Node (Leaf, "vq", Leaf), "uo", Node (Leaf, "qg", Node (Node (Leaf, "uf", Leaf), "of", Node (Node (Node (Leaf, "es", Node (Node (Node (Node (Leaf, "ht", Leaf), "nl", Leaf), "xt", Node (Leaf, "il", Leaf)), "ym", Node (Node (Leaf, "fu", Node (Leaf, "qg", Node (Leaf, "ao", Node (Node (Node (Leaf, "am", Leaf), "tg", Node (Leaf, "kx", Leaf)), "lo", Leaf)))), "ad", Node (Leaf, "dp", Leaf)))), "za", Node (Node (Leaf, "kr", Node (Leaf, "wp", Leaf)), "ji", Node (Leaf, "dc", Node (Leaf, "qk", Node (Leaf, "sd", Leaf))))), "wx", Node (Leaf, "dl", Leaf))))), "zt", Leaf))), "qv", Leaf), "fh", Node (Node (Node (Leaf, "cg", Node (Node (Leaf, "hf", Leaf), "nw", Leaf)), "dj", Node (Leaf, "ge", Node (Node (Node (Leaf, "mv", Leaf), "ap", Leaf), "lb", Leaf))), "ks", Leaf))), "bf", Node (Node (Node (Leaf, "um", Node (Leaf, "jj", Leaf)), "uk", Node (Leaf, "kb", Node (Node (Leaf, "vx", Leaf), "on", Leaf))), "wn", Node (Leaf, "gb", Leaf)))
val bt15 = Node (Leaf, "tv", Node (Leaf, "bp", Node (Node (Node (Node (Leaf, "dh", Leaf), "qw", Node (Leaf, "wj", Node (Leaf, "hq", Leaf))), "uc", Node (Node (Leaf, "ed", Leaf), "xj", Leaf)), "vm", Node (Leaf, "st", Leaf))))
val bt16 = Node (Node (Leaf, "pm", Leaf), "xr", Node (Node (Leaf, "jp", Leaf), "rw", Leaf))
val bt17 = Node (Node (Node (Leaf, "kx", Leaf), "ez", Node (Leaf, "cs", Leaf)), "ie", Node (Node (Leaf, "aj", Leaf), "bx", Node (Leaf, "za", Leaf)))
val bt18 = Node (Node (Node (Node (Leaf, "mh", Leaf), "zh", Node (Leaf, "sy", Leaf)), "uu", Node (Node (Node (Leaf, "jq", Leaf), "bc", Node (Leaf, "gv", Leaf)), "jg", Node (Leaf, "ld", Node (Leaf, "ew", Leaf)))), "dx", Node (Node (Leaf, "to", Node (Leaf, "cd", Leaf)), "vu", Node (Node (Leaf, "ey", Leaf), "bk", Node (Node (Leaf, "wb", Leaf), "ue", Node (Leaf, "zx", Leaf)))))
val bt19 = Node (Node (Node (Node (Node (Leaf, "mp", Leaf), "ip", Node (Leaf, "wh", Leaf)), "su", Node (Leaf, "vu", Node (Leaf, "jd", Leaf))), "tf", Node (Node (Node (Leaf, "wr", Node (Leaf, "uy", Leaf)), "va", Node (Node (Leaf, "mp", Leaf), "ys", Leaf)), "ti", Node (Node (Node (Leaf, "uc", Leaf), "fj", Node (Leaf, "rg", Leaf)), "vi", Node (Leaf, "lk", Node (Leaf, "kz", Leaf))))), "uo", Node (Node (Node (Node (Leaf, "xs", Leaf), "sp", Node (Node (Leaf, "cz", Leaf), "ug", Node (Leaf, "gm", Leaf))), "rr", Node (Node (Leaf, "dm", Leaf), "do", Node (Node (Leaf, "ij", Leaf), "eq", Node (Leaf, "zv", Leaf)))), "gk", Node (Node (Node (Node (Leaf, "ao", Leaf), "gh", Node (Leaf, "ne", Leaf)), "zc", Node (Node (Leaf, "ld", Leaf), "gs", Node (Leaf, "cs", Leaf))), "ur", Node (Node (Leaf, "wf", Leaf), "uu", Node (Node (Leaf, "hh", Leaf), "ku", Node (Leaf, "gg", Leaf))))))
val bt20 = Node (Node (Node (Node (Node (Node (Leaf, "yl", Leaf), "cn", Node (Node (Leaf, "na", Leaf), "kd", Node (Leaf, "wa", Leaf))), "yj", Node (Node (Leaf, "db", Leaf), "dx", Node (Node (Leaf, "rn", Leaf), "hv", Node (Leaf, "ar", Leaf)))), "jc", Node (Node (Node (Leaf, "lb", Node (Leaf, "cl", Leaf)), "ql", Node (Leaf, "rt", Node (Leaf, "wt", Leaf))), "nt", Node (Node (Node (Leaf, "bc", Leaf), "vc", Leaf), "ta", Node (Node (Leaf, "xo", Leaf), "ue", Node (Leaf, "go", Leaf))))), "dw", Node (Node (Node (Node (Node (Leaf, "th", Leaf), "sp", Node (Leaf, "fo", Leaf)), "qp", Node (Node (Leaf, "tc", Leaf), "cx", Node (Leaf, "aw", Leaf))), "qj", Node (Node (Node (Leaf, "vg", Leaf), "nj", Node (Leaf, "fq", Leaf)), "ed", Node (Node (Leaf, "xz", Leaf), "lh", Leaf))), "zy", Node (Node (Node (Leaf, "xn", Leaf), "il", Node (Leaf, "qw", Leaf)), "pw", Node (Node (Leaf, "tq", Leaf), "vr", Node (Leaf, "fm", Leaf))))), "qe", Node (Node (Node (Node (Node (Leaf, "ul", Leaf), "uj", Node (Leaf, "py", Leaf)), "xo", Node (Node (Node (Leaf, "rw", Leaf), "uq", Node (Leaf, "fe", Leaf)), "kz", Node (Node (Leaf, "fz", Leaf), "cm", Node (Leaf, "fr", Leaf)))), "dz", Node (Node (Node (Node (Leaf, "jm", Leaf), "oa", Node (Leaf, "gv", Leaf)), "yp", Node (Node (Leaf, "pm", Leaf), "zs", Node (Leaf, "lo", Leaf))), "mz", Node (Node (Node (Leaf, "wu", Leaf), "qi", Node (Leaf, "me", Leaf)), "zf", Node (Node (Leaf, "jh", Leaf), "qc", Node (Leaf, "wv", Leaf))))), "xa", Node (Node (Node (Node (Node (Leaf, "so", Leaf), "eo", Node (Leaf, "ap", Leaf)), "sh", Node (Node (Leaf, "gx", Leaf), "an", Node (Leaf, "xd", Leaf))), "js", Node (Leaf, "jj", Leaf)), "la", Node (Node (Node (Leaf, "tz", Node (Leaf, "bi", Leaf)), "ko", Node (Node (Leaf, "mo", Leaf), "ij", Node (Leaf, "dg", Leaf))), "rx", Node (Node (Leaf, "id", Node (Leaf, "oh", Leaf)), "xn", Node (Node (Leaf, "ix", Leaf), "eo", Node (Leaf, "sd", Leaf)))))))
val bt21 = Leaf
val bt22 = Node (Leaf, 430, Leaf)
val bt23 = Node (Node (Leaf, ~382, Node (Leaf, 534, Node (Leaf, 393, Node (Node (Node (Node (Node (Node (Leaf, 447, Leaf), ~514, Node (Leaf, 8, Leaf)), ~500, Leaf), ~923, Leaf), 448, Node (Node (Leaf, 730, Node (Leaf, ~797, Leaf)), 492, Node (Leaf, ~700, Leaf))), 270, Leaf)))), ~649, Leaf)
val bt24 = Node (Leaf, ~391, Node (Node (Leaf, 851, Node (Leaf, ~816, Leaf)), ~447, Leaf))
val bt25 = Node (Node (Leaf, ~24, Leaf), 569, Node (Node (Leaf, 952, Node (Leaf, 702, Leaf)), ~843, Node (Node (Node (Node (Node (Node (Leaf, 471, Leaf), 113, Leaf), 20, Node (Leaf, ~787, Node (Node (Leaf, ~242, Leaf), 657, Node (Node (Node (Leaf, ~666, Leaf), 576, Leaf), 669, Leaf)))), ~492, Leaf), 180, Node (Leaf, ~489, Node (Node (Node (Leaf, 980, Node (Leaf, 628, Node (Node (Leaf, 314, Leaf), ~261, Node (Leaf, ~467, Leaf)))), 157, Node (Leaf, 822, Leaf)), ~495, Node (Leaf, 448, Node (Leaf, ~591, Leaf))))), 165, Node (Node (Leaf, 72, Leaf), ~505, Leaf))))
val bt26 = Node (Node (Leaf, ~674, Node (Leaf, 638, Leaf)), ~138, Leaf)
val bt27 = Node (Node (Leaf, ~534, Leaf), ~856, Leaf)
val bt28 = Node (Node (Node (Leaf, 362, Leaf), ~925, Node (Leaf, ~950, Node (Leaf, ~755, Node (Leaf, ~713, Node (Node (Node (Leaf, 824, Leaf), 435, Leaf), ~437, Node (Node (Leaf, ~147, Leaf), ~393, Leaf)))))), 227, Leaf)
val bt29 = Node (Node (Node (Leaf, ~230, Node (Node (Leaf, 217, Leaf), 528, Leaf)), 520, Leaf), ~867, Leaf)
val bt30 = Node (Leaf, 997, Node (Node (Node (Leaf, 72, Leaf), ~340, Node (Leaf, 48, Node (Node (Leaf, ~994, Leaf), 217, Leaf))), ~61, Node (Leaf, ~658, Node (Leaf, ~935, Node (Leaf, 684, Leaf)))))
val bt31 = Node (Leaf, 959, Node (Leaf, ~852, Node (Node (Node (Node (Node (Node (Node (Node (Node (Leaf, 637, Leaf), ~581, Node (Node (Node (Leaf, 850, Node (Leaf, ~1023, Node (Node (Leaf, ~94, Node (Leaf, 917, Leaf)), ~51, Leaf))), ~428, Node (Node (Node (Node (Leaf, 890, Node (Node (Leaf, 973, Node (Leaf, 519, Leaf)), ~314, Node (Node (Leaf, ~695, Leaf), 764, Leaf))), 560, Leaf), 251, Node (Leaf, 40, Node (Node (Node (Node (Leaf, 408, Leaf), ~383, Leaf), 167, Node (Leaf, 109, Leaf)), ~833, Node (Node (Leaf, 268, Leaf), ~530, Node (Leaf, ~180, Leaf))))), 86, Leaf)), 586, Leaf)), 646, Node (Node (Node (Node (Node (Node (Leaf, ~695, Node (Leaf, 474, Leaf)), ~265, Node (Node (Node (Leaf, ~181, Leaf), 41, Leaf), 151, Node (Leaf, 13, Leaf))), ~382, Leaf), 351, Leaf), ~684, Leaf), ~516, Leaf)), 223, Node (Leaf, ~500, Leaf)), 127, Leaf), ~315, Leaf), 883, Node (Leaf, ~684, Node (Node (Node (Leaf, 272, Node (Node (Leaf, ~909, Leaf), ~54, Node (Leaf, ~795, Leaf))), 732, Leaf), 895, Leaf))), 37, Node (Leaf, ~575, Leaf)), ~106, Node (Leaf, ~616, Node (Node (Leaf, 727, Leaf), ~189, Leaf)))))
val bt32 = Node (Node (Node (Leaf, 725, Node (Node (Node (Leaf, ~149, Leaf), 269, Node (Leaf, ~802, Leaf)), 924, Node (Node (Leaf, 249, Node (Leaf, 718, Node (Leaf, ~554, Node (Node (Leaf, ~621, Node (Node (Node (Leaf, ~577, Node (Leaf, 44, Leaf)), 76, Node (Leaf, 693, Leaf)), 780, Node (Node (Leaf, 629, Leaf), ~138, Node (Node (Leaf, 613, Leaf), ~993, Node (Leaf, 731, Leaf))))), 671, Leaf)))), 903, Leaf))), 178, Node (Node (Node (Node (Node (Node (Leaf, 629, Leaf), ~3, Leaf), 30, Node (Node (Node (Leaf, 157, Leaf), 491, Node (Leaf, 461, Leaf)), 585, Leaf)), 24, Node (Leaf, 617, Leaf)), ~96, Node (Leaf, 432, Node (Node (Leaf, ~18, Node (Node (Node (Node (Node (Leaf, 612, Leaf), ~656, Node (Leaf, ~483, Leaf)), 409, Node (Node (Node (Node (Node (Leaf, 580, Leaf), ~206, Leaf), ~683, Leaf), 517, Leaf), 231, Node (Node (Node (Node (Leaf, ~477, Node (Leaf, ~215, Leaf)), ~316, Leaf), ~764, Leaf), ~572, Leaf))), 561, Node (Leaf, 331, Leaf)), ~12, Leaf)), 894, Leaf))), 369, Leaf)), ~762, Leaf)
val bt33 = Node (Node (Leaf, ~541, Node (Leaf, 203, Leaf)), 735, Node (Node (Node (Node (Node (Node (Leaf, ~681, Leaf), 509, Node (Leaf, ~136, Leaf)), 649, Node (Leaf, 970, Node (Leaf, 72, Node (Node (Node (Node (Leaf, 874, Leaf), 415, Node (Node (Leaf, 313, Node (Leaf, 49, Leaf)), ~880, Leaf)), ~537, Leaf), ~202, Leaf)))), ~631, Leaf), 863, Leaf), 318, Node (Node (Leaf, 462, Node (Leaf, 876, Node (Node (Leaf, ~512, Node (Leaf, 828, Leaf)), ~186, Leaf))), 684, Leaf)))
val bt34 = Node (Node (Leaf, ~377, Node (Leaf, 42, Node (Node (Node (Node (Node (Leaf, ~250, Leaf), ~719, Leaf), 573, Leaf), ~732, Node (Node (Leaf, ~358, Node (Node (Node (Node (Node (Node (Leaf, ~513, Leaf), 649, Leaf), ~464, Node (Leaf, ~32, Leaf)), 75, Leaf), 207, Leaf), 187, Node (Node (Node (Node (Leaf, 378, Node (Node (Leaf, 943, Leaf), 107, Node (Leaf, 35, Leaf))), ~566, Leaf), ~341, Leaf), 99, Node (Leaf, ~233, Leaf)))), ~767, Leaf)), ~132, Leaf))), 643, Node (Node (Leaf, 716, Node (Leaf, ~114, Node (Node (Leaf, 35, Node (Node (Leaf, 459, Leaf), 678, Node (Node (Node (Node (Leaf, 965, Leaf), 37, Node (Leaf, 440, Leaf)), 17, Leaf), 188, Node (Leaf, 10, Leaf)))), ~474, Leaf))), 108, Node (Leaf, 484, Leaf)))
val bt35 = Node (Leaf, ~943, Node (Node (Leaf, ~955, Node (Node (Node (Leaf, 30, Leaf), 710, Leaf), ~543, Leaf)), 142, Node (Leaf, 92, Leaf)))
val bt36 = Node (Node (Leaf, ~699, Leaf), 147, Node (Leaf, 235, Leaf))
val bt37 = Node (Node (Node (Node (Leaf, 925, Leaf), 367, Leaf), ~357, Node (Node (Leaf, ~371, Leaf), ~399, Node (Leaf, ~855, Leaf))), ~765, Node (Node (Leaf, ~117, Leaf), ~843, Node (Leaf, ~448, Leaf)))
val bt38 = Node (Node (Node (Node (Leaf, 91, Node (Leaf, ~49, Leaf)), ~750, Node (Node (Leaf, ~140, Leaf), ~703, Leaf)), 317, Node (Node (Node (Leaf, ~231, Leaf), ~609, Node (Leaf, ~103, Leaf)), 460, Node (Node (Leaf, 323, Leaf), ~552, Node (Leaf, 781, Leaf)))), ~598, Node (Node (Node (Node (Leaf, ~827, Leaf), ~822, Node (Leaf, ~280, Leaf)), ~700, Node (Node (Leaf, 822, Leaf), ~4, Node (Leaf, 770, Leaf))), 182, Node (Node (Leaf, 780, Node (Leaf, 729, Leaf)), ~433, Node (Leaf, 130, Node (Leaf, ~263, Leaf)))))
val bt39 = Node (Node (Node (Node (Node (Leaf, 363, Leaf), ~809, Leaf), ~176, Node (Node (Leaf, ~439, Leaf), ~254, Node (Leaf, 550, Leaf))), 690, Node (Node (Node (Leaf, 319, Leaf), 530, Node (Leaf, 580, Leaf)), ~190, Node (Leaf, 632, Leaf))), ~305, Node (Node (Node (Node (Node (Leaf, ~283, Leaf), ~727, Node (Leaf, 1022, Leaf)), 535, Node (Node (Leaf, 369, Leaf), ~869, Leaf)), 278, Node (Node (Leaf, ~892, Leaf), 159, Leaf)), 344, Node (Node (Node (Leaf, ~983, Node (Leaf, ~23, Leaf)), ~131, Node (Node (Leaf, 237, Leaf), 232, Leaf)), ~772, Node (Node (Node (Leaf, ~355, Leaf), 939, Node (Leaf, ~477, Leaf)), 517, Node (Leaf, ~128, Node (Leaf, ~340, Leaf))))))
val bt40 = Node (Node (Node (Node (Node (Node (Node (Leaf, 1002, Leaf), ~30, Node (Leaf, 603, Leaf)), 896, Node (Leaf, 622, Leaf)), ~279, Node (Node (Node (Leaf, ~470, Leaf), ~686, Node (Leaf, 156, Leaf)), ~202, Node (Leaf, 428, Leaf))), ~363, Node (Node (Node (Leaf, 426, Leaf), ~183, Node (Leaf, ~586, Leaf)), 470, Node (Node (Leaf, 434, Leaf), 81, Node (Leaf, ~391, Leaf)))), ~293, Node (Node (Node (Node (Leaf, ~529, Leaf), 278, Leaf), ~846, Node (Node (Leaf, ~306, Leaf), 404, Node (Leaf, ~27, Leaf))), 518, Node (Node (Node (Leaf, ~275, Leaf), ~414, Node (Leaf, 814, Leaf)), ~715, Node (Node (Leaf, 958, Leaf), 714, Node (Leaf, 697, Leaf))))), 388, Node (Node (Node (Node (Node (Leaf, ~907, Leaf), ~901, Node (Node (Leaf, ~130, Leaf), 716, Node (Leaf, 799, Leaf))), 137, Node (Node (Node (Leaf, 768, Leaf), ~657, Node (Leaf, ~978, Leaf)), ~660, Node (Leaf, ~350, Leaf))), ~22, Node (Node (Node (Node (Leaf, 350, Leaf), ~491, Leaf), 578, Node (Node (Leaf, 866, Leaf), ~980, Node (Leaf, 537, Leaf))), ~640, Node (Node (Leaf, 315, Leaf), ~533, Leaf))), 691, Node (Node (Node (Node (Node (Leaf, 498, Leaf), ~385, Node (Leaf, ~511, Leaf)), 52, Node (Node (Leaf, 354, Leaf), ~285, Node (Leaf, 842, Leaf))), 163, Node (Node (Leaf, ~339, Node (Leaf, 462, Leaf)), ~893, Node (Node (Leaf, ~258, Leaf), ~194, Node (Leaf, ~456, Leaf)))), ~453, Node (Node (Node (Leaf, ~853, Leaf), ~258, Node (Node (Leaf, 72, Leaf), 509, Node (Leaf, 230, Leaf))), 302, Node (Node (Leaf, ~530, Leaf), 561, Node (Leaf, 828, Leaf))))))


(* btree_size tests *)
val btree_size_test01 = ("btree_size_test01", bt01, 9)
val btree_size_test02 = ("btree_size_test02", bt02, 0)
val btree_size_test03 = ("btree_size_test03", bt03, 5)
val btree_size_test04 = ("btree_size_test04", bt04, 1)
val btree_size_test05 = ("btree_size_test05", bt05, 27)
val btree_size_test06 = ("btree_size_test06", bt06, 6)
val btree_size_test07 = ("btree_size_test07", bt07, 36)
val btree_size_test08 = ("btree_size_test08", bt08, 29)
val btree_size_test09 = ("btree_size_test09", bt09, 13)
val btree_size_test10 = ("btree_size_test10", bt10, 3)
val btree_size_test11 = ("btree_size_test11", bt11, 16)
val btree_size_test12 = ("btree_size_test12", bt12, 43)
val btree_size_test13 = ("btree_size_test13", bt13, 55)
val btree_size_test14 = ("btree_size_test14", bt14, 79)
val btree_size_test15 = ("btree_size_test15", bt15, 11)
val btree_size_test16 = ("btree_size_test16", bt16, 4)
val btree_size_test17 = ("btree_size_test17", bt17, 7)
val btree_size_test18 = ("btree_size_test18", bt18, 19)
val btree_size_test19 = ("btree_size_test19", bt19, 45)
val btree_size_test20 = ("btree_size_test20", bt20, 99)
val btree_size_test21 = ("btree_size_test21", bt21, 0)
val btree_size_test22 = ("btree_size_test22", bt22, 1)
val btree_size_test23 = ("btree_size_test23", bt23, 15)
val btree_size_test24 = ("btree_size_test24", bt24, 4)
val btree_size_test25 = ("btree_size_test25", bt25, 30)
val btree_size_test26 = ("btree_size_test26", bt26, 3)
val btree_size_test27 = ("btree_size_test27", bt27, 2)
val btree_size_test28 = ("btree_size_test28", bt28, 11)
val btree_size_test29 = ("btree_size_test29", bt29, 5)
val btree_size_test30 = ("btree_size_test30", bt30, 10)
val btree_size_test31 = ("btree_size_test31", bt31, 59)
val btree_size_test32 = ("btree_size_test32", bt32, 54)
val btree_size_test33 = ("btree_size_test33", bt33, 25)
val btree_size_test34 = ("btree_size_test34", bt34, 39)
val btree_size_test35 = ("btree_size_test35", bt35, 7)
val btree_size_test36 = ("btree_size_test36", bt36, 3)
val btree_size_test37 = ("btree_size_test37", bt37, 10)
val btree_size_test38 = ("btree_size_test38", bt38, 27)
val btree_size_test39 = ("btree_size_test39", bt39, 35)
val btree_size_test40 = ("btree_size_test40", bt40, 81)
val btree_size_testsS = [btree_size_test01,btree_size_test02,btree_size_test03,btree_size_test04,btree_size_test05,btree_size_test06,btree_size_test07,btree_size_test08,btree_size_test09,btree_size_test10,btree_size_test11,btree_size_test12,btree_size_test13,btree_size_test14,btree_size_test15,btree_size_test16,btree_size_test17,btree_size_test18,btree_size_test19,btree_size_test20]
val btree_size_testsI = [btree_size_test21,btree_size_test22,btree_size_test23,btree_size_test24,btree_size_test25,btree_size_test26,btree_size_test27,btree_size_test28,btree_size_test29,btree_size_test30,btree_size_test31,btree_size_test32,btree_size_test33,btree_size_test34,btree_size_test35,btree_size_test36,btree_size_test37,btree_size_test38,btree_size_test39,btree_size_test40]
(* Uncomment the following to test your btree_size function. *)
val _ = run_tests btree_size int_equal btree_size_testsS 
val _ = run_tests btree_size int_equal btree_size_testsI 


(* btree_height tests *)
val btree_height_test01 = ("btree_height_test01", bt01, 6)
val btree_height_test02 = ("btree_height_test02", bt02, 0)
val btree_height_test03 = ("btree_height_test03", bt03, 5)
val btree_height_test04 = ("btree_height_test04", bt04, 1)
val btree_height_test05 = ("btree_height_test05", bt05, 13)
val btree_height_test06 = ("btree_height_test06", bt06, 6)
val btree_height_test07 = ("btree_height_test07", bt07, 17)
val btree_height_test08 = ("btree_height_test08", bt08, 16)
val btree_height_test09 = ("btree_height_test09", bt09, 7)
val btree_height_test10 = ("btree_height_test10", bt10, 3)
val btree_height_test11 = ("btree_height_test11", bt11, 12)
val btree_height_test12 = ("btree_height_test12", bt12, 12)
val btree_height_test13 = ("btree_height_test13", bt13, 23)
val btree_height_test14 = ("btree_height_test14", bt14, 21)
val btree_height_test15 = ("btree_height_test15", bt15, 7)
val btree_height_test16 = ("btree_height_test16", bt16, 3)
val btree_height_test17 = ("btree_height_test17", bt17, 3)
val btree_height_test18 = ("btree_height_test18", bt18, 5)
val btree_height_test19 = ("btree_height_test19", bt19, 6)
val btree_height_test20 = ("btree_height_test20", bt20, 7)
val btree_height_test21 = ("btree_height_test21", bt21, 0)
val btree_height_test22 = ("btree_height_test22", bt22, 1)
val btree_height_test23 = ("btree_height_test23", bt23, 10)
val btree_height_test24 = ("btree_height_test24", bt24, 4)
val btree_height_test25 = ("btree_height_test25", bt25, 11)
val btree_height_test26 = ("btree_height_test26", bt26, 3)
val btree_height_test27 = ("btree_height_test27", bt27, 2)
val btree_height_test28 = ("btree_height_test28", bt28, 8)
val btree_height_test29 = ("btree_height_test29", bt29, 5)
val btree_height_test30 = ("btree_height_test30", bt30, 6)
val btree_height_test31 = ("btree_height_test31", bt31, 19)
val btree_height_test32 = ("btree_height_test32", bt32, 16)
val btree_height_test33 = ("btree_height_test33", bt33, 13)
val btree_height_test34 = ("btree_height_test34", bt34, 14)
val btree_height_test35 = ("btree_height_test35", bt35, 6)
val btree_height_test36 = ("btree_height_test36", bt36, 2)
val btree_height_test37 = ("btree_height_test37", bt37, 4)
val btree_height_test38 = ("btree_height_test38", bt38, 5)
val btree_height_test39 = ("btree_height_test39", bt39, 6)
val btree_height_test40 = ("btree_height_test40", bt40, 7)
val btree_height_testsS = [btree_height_test01,btree_height_test02,btree_height_test03,btree_height_test04,btree_height_test05,btree_height_test06,btree_height_test07,btree_height_test08,btree_height_test09,btree_height_test10,btree_height_test11,btree_height_test12,btree_height_test13,btree_height_test14,btree_height_test15,btree_height_test16,btree_height_test17,btree_height_test18,btree_height_test19,btree_height_test20]
val btree_height_testsI = [btree_height_test21,btree_height_test22,btree_height_test23,btree_height_test24,btree_height_test25,btree_height_test26,btree_height_test27,btree_height_test28,btree_height_test29,btree_height_test30,btree_height_test31,btree_height_test32,btree_height_test33,btree_height_test34,btree_height_test35,btree_height_test36,btree_height_test37,btree_height_test38,btree_height_test39,btree_height_test40]
(* Uncomment the following to test your btree_height function. *)
val _ = run_tests btree_height int_equal btree_height_testsS
val _ = run_tests btree_height int_equal btree_height_testsI


(* btree_deepest tests *)
val btree_deepest_test01 = ("btree_deepest_test01", bt01, ["yg"])
val btree_deepest_test02 = ("btree_deepest_test02", bt02, [])
val btree_deepest_test03 = ("btree_deepest_test03", bt03, ["yp"])
val btree_deepest_test04 = ("btree_deepest_test04", bt04, ["mx"])
val btree_deepest_test05 = ("btree_deepest_test05", bt05, ["ip"])
val btree_deepest_test06 = ("btree_deepest_test06", bt06, ["dj"])
val btree_deepest_test07 = ("btree_deepest_test07", bt07, ["qc"])
val btree_deepest_test08 = ("btree_deepest_test08", bt08, ["zh"])
val btree_deepest_test09 = ("btree_deepest_test09", bt09, ["uf"])
val btree_deepest_test10 = ("btree_deepest_test10", bt10, ["eo"])
val btree_deepest_test11 = ("btree_deepest_test11", bt11, ["tn"])
val btree_deepest_test12 = ("btree_deepest_test12", bt12, ["cw"])
val btree_deepest_test13 = ("btree_deepest_test13", bt13, ["ag"])
val btree_deepest_test14 = ("btree_deepest_test14", bt14, ["am","kx"])
val btree_deepest_test15 = ("btree_deepest_test15", bt15, ["hq"])
val btree_deepest_test16 = ("btree_deepest_test16", bt16, ["jp"])
val btree_deepest_test17 = ("btree_deepest_test17", bt17, ["kx","cs","aj","za"])
val btree_deepest_test18 = ("btree_deepest_test18", bt18, ["jq","gv","ew","wb","zx"])
val btree_deepest_test19 = ("btree_deepest_test19", bt19, ["uy","mp","uc","rg","kz","cz","gm","ij","zv","ao","ne","ld","cs","hh","gg"])
val btree_deepest_test20 = ("btree_deepest_test20", bt20, ["na","wa","rn","ar","cl","wt","bc","xo","go","th","fo","tc","aw","vg","fq","xz","rw","fe","fz","fr","jm","gv","pm","lo","wu","me","jh","wv","so","ap","gx","xd","bi","mo","dg","oh","ix","sd"])
val btree_deepest_test21 = ("btree_deepest_test21", bt21, [])
val btree_deepest_test22 = ("btree_deepest_test22", bt22, [430])
val btree_deepest_test23 = ("btree_deepest_test23", bt23, [447,8])
val btree_deepest_test24 = ("btree_deepest_test24", bt24, [~816])
val btree_deepest_test25 = ("btree_deepest_test25", bt25, [~666,314,~467])
val btree_deepest_test26 = ("btree_deepest_test26", bt26, [638])
val btree_deepest_test27 = ("btree_deepest_test27", bt27, [~534])
val btree_deepest_test28 = ("btree_deepest_test28", bt28, [824,~147])
val btree_deepest_test29 = ("btree_deepest_test29", bt29, [217])
val btree_deepest_test30 = ("btree_deepest_test30", bt30, [~994])
val btree_deepest_test31 = ("btree_deepest_test31", bt31, [519,~695,408])
val btree_deepest_test32 = ("btree_deepest_test32", bt32, [~215])
val btree_deepest_test33 = ("btree_deepest_test33", bt33, [49])
val btree_deepest_test34 = ("btree_deepest_test34", bt34, [943,35])
val btree_deepest_test35 = ("btree_deepest_test35", bt35, [30])
val btree_deepest_test36 = ("btree_deepest_test36", bt36, [~699,235])
val btree_deepest_test37 = ("btree_deepest_test37", bt37, [925,~371,~855])
val btree_deepest_test38 = ("btree_deepest_test38", bt38, [~49,~140,~231,~103,323,781,~827,~280,822,770,729,~263])
val btree_deepest_test39 = ("btree_deepest_test39", bt39, [~283,1022,369,~23,237,~355,~477,~340])
val btree_deepest_test40 = ("btree_deepest_test40", bt40, [1002,603,~470,156,~130,799,768,~978,350,866,537,498,~511,354,842,462,~258,~456,72,230])
val btree_deepest_testsS = [btree_deepest_test01,btree_deepest_test02,btree_deepest_test03,btree_deepest_test04,btree_deepest_test05,btree_deepest_test06,btree_deepest_test07,btree_deepest_test08,btree_deepest_test09,btree_deepest_test10,btree_deepest_test11,btree_deepest_test12,btree_deepest_test13,btree_deepest_test14,btree_deepest_test15,btree_deepest_test16,btree_deepest_test17,btree_deepest_test18,btree_deepest_test19,btree_deepest_test20]
val btree_deepest_testsI = [btree_deepest_test21,btree_deepest_test22,btree_deepest_test23,btree_deepest_test24,btree_deepest_test25,btree_deepest_test26,btree_deepest_test27,btree_deepest_test28,btree_deepest_test29,btree_deepest_test30,btree_deepest_test31,btree_deepest_test32,btree_deepest_test33,btree_deepest_test34,btree_deepest_test35,btree_deepest_test36,btree_deepest_test37,btree_deepest_test38,btree_deepest_test39,btree_deepest_test40]
(* Uncomment the following to test your btree_deepest function. *)
val _ = run_tests btree_deepest (list_equal string_equal) btree_deepest_testsS
val _ = run_tests btree_deepest (list_equal int_equal) btree_deepest_testsI


(* btree_max tests *)
val btree_max_test01 = ("btree_max_test01", bt01, SOME("yg"))
val btree_max_test02 = ("btree_max_test02", bt02, NONE)
val btree_max_test03 = ("btree_max_test03", bt03, SOME("yp"))
val btree_max_test04 = ("btree_max_test04", bt04, SOME("mx"))
val btree_max_test05 = ("btree_max_test05", bt05, SOME("xo"))
val btree_max_test06 = ("btree_max_test06", bt06, SOME("vh"))
val btree_max_test07 = ("btree_max_test07", bt07, SOME("zn"))
val btree_max_test08 = ("btree_max_test08", bt08, SOME("zh"))
val btree_max_test09 = ("btree_max_test09", bt09, SOME("zv"))
val btree_max_test10 = ("btree_max_test10", bt10, SOME("vy"))
val btree_max_test11 = ("btree_max_test11", bt11, SOME("zi"))
val btree_max_test12 = ("btree_max_test12", bt12, SOME("zy"))
val btree_max_test13 = ("btree_max_test13", bt13, SOME("zp"))
val btree_max_test14 = ("btree_max_test14", bt14, SOME("zt"))
val btree_max_test15 = ("btree_max_test15", bt15, SOME("xj"))
val btree_max_test16 = ("btree_max_test16", bt16, SOME("xr"))
val btree_max_test17 = ("btree_max_test17", bt17, SOME("za"))
val btree_max_test18 = ("btree_max_test18", bt18, SOME("zx"))
val btree_max_test19 = ("btree_max_test19", bt19, SOME("zv"))
val btree_max_test20 = ("btree_max_test20", bt20, SOME("zy"))
val btree_max_test21 = ("btree_max_test21", bt21, NONE)
val btree_max_test22 = ("btree_max_test22", bt22, SOME(430))
val btree_max_test23 = ("btree_max_test23", bt23, SOME(730))
val btree_max_test24 = ("btree_max_test24", bt24, SOME(851))
val btree_max_test25 = ("btree_max_test25", bt25, SOME(980))
val btree_max_test26 = ("btree_max_test26", bt26, SOME(638))
val btree_max_test27 = ("btree_max_test27", bt27, SOME(~534))
val btree_max_test28 = ("btree_max_test28", bt28, SOME(824))
val btree_max_test29 = ("btree_max_test29", bt29, SOME(528))
val btree_max_test30 = ("btree_max_test30", bt30, SOME(997))
val btree_max_test31 = ("btree_max_test31", bt31, SOME(973))
val btree_max_test32 = ("btree_max_test32", bt32, SOME(924))
val btree_max_test33 = ("btree_max_test33", bt33, SOME(970))
val btree_max_test34 = ("btree_max_test34", bt34, SOME(965))
val btree_max_test35 = ("btree_max_test35", bt35, SOME(710))
val btree_max_test36 = ("btree_max_test36", bt36, SOME(235))
val btree_max_test37 = ("btree_max_test37", bt37, SOME(925))
val btree_max_test38 = ("btree_max_test38", bt38, SOME(822))
val btree_max_test39 = ("btree_max_test39", bt39, SOME(1022))
val btree_max_test40 = ("btree_max_test40", bt40, SOME(1002))
val btree_max_testsS = [btree_max_test01,btree_max_test02,btree_max_test03,btree_max_test04,btree_max_test05,btree_max_test06,btree_max_test07,btree_max_test08,btree_max_test09,btree_max_test10,btree_max_test11,btree_max_test12,btree_max_test13,btree_max_test14,btree_max_test15,btree_max_test16,btree_max_test17,btree_max_test18,btree_max_test19,btree_max_test20]
val btree_max_testsI = [btree_max_test21,btree_max_test22,btree_max_test23,btree_max_test24,btree_max_test25,btree_max_test26,btree_max_test27,btree_max_test28,btree_max_test29,btree_max_test30,btree_max_test31,btree_max_test32,btree_max_test33,btree_max_test34,btree_max_test35,btree_max_test36,btree_max_test37,btree_max_test38,btree_max_test39,btree_max_test40]
(* Uncomment the following to test your btree_max function. *)
val _ = run_tests (btree_max String.compare) (option_equal string_equal) btree_max_testsS
val _ = run_tests (btree_max Int.compare) (option_equal int_equal) btree_max_testsI

in
end
