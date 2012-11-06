(* The datatype representing a formula. *)
datatype fmla =
   F_Var of string
 | F_Not of fmla
 | F_And of fmla * fmla
 | F_Or of fmla * fmla


(* Convert a formula to a string. *)
fun formula_to_string (f: fmla) : string =
   case f of
      F_Var s => s
    | F_Not f => concat ["(", formula_to_string f, " !)"]
    | F_And (f1, f2) => concat ["(", formula_to_string f1, " ", formula_to_string f2, " &)"]
    | F_Or (f1, f2) => concat ["(", formula_to_string f1, " ", formula_to_string f2, " |)"]


(* Compare formulas for equality. *)
fun formula_equal (f1, f2) =
   case (f1, f2) of
      (F_Var s1, F_Var s2) => s1 = s2
    | (F_Not f1, F_Not f2) => formula_equal (f1, f2)
    | (F_And (f11, f12), F_And (f21, f22)) => formula_equal (f11, f21) andalso formula_equal (f12, f22)
    | (F_Or (f11, f12), F_Or (f21, f22)) => formula_equal (f11, f21) andalso formula_equal (f12, f22)
    | _ => false


(* DEFINE varsOf_formula HERE. *)
(* varsOf_formula : fmla -> string list *)
fun varsOf_formula fmla = 
	let 
		(* Strip out duplicates in the list l *)
		fun uniquify l = 
			(case l of
				[] => []
				| h::t => h::(List.filter (fn x => x <> h) (uniquify t)))
		
		(* Build a list containing every instance of variables in the formula *)
		fun buildVarList fmla = 
			case fmla of 
				F_Var s => [s]
				| F_Not f => buildVarList(f)
				| F_And (fa1, fa2) => buildVarList(fa1) @ buildVarList(fa2)
				| F_Or (fo1, fo2) => buildVarList(fo1) @ buildVarList(fo2)
	in
		(* Uniquify the list of all variables from the formula *)
		uniquify (buildVarList fmla)
	end


(* DEFINE eval_formula HERE. *)
(* eval_formula : (string -> bool) -> fmla -> bool *)
fun eval_formula varMap fmla = 
	case fmla of 
		F_Var s => varMap(s)
		| F_Not f => not (eval_formula varMap f)
		| F_And (fa1, fa2) => (eval_formula varMap fa1) andalso (eval_formula varMap fa2)
		| F_Or (fo1, fo2) => (eval_formula varMap fo1) orelse (eval_formula varMap fo2)


(* DEFINE tautology_formula HERE. *)
(* tautology_formula : fmla -> bool *)
(* try to do some inner function that gets all variables, defines a map, and then flips the value of every map*)


(* The datatype representing a token. *)
datatype tok =
   T_LParen
 | T_RParen
 | T_Var of string
 | T_Not
 | T_And
 | T_Or


(* Convert a formula to a list of tokens. *)
fun formula_to_tokenList (f: fmla) : tok list =
   case f of
      F_Var s => [T_Var s]
    | F_Not f => [T_LParen] @ (formula_to_tokenList f) @ [T_Not, T_RParen]
    | F_And (f1, f2) => [T_LParen] @ (formula_to_tokenList f1) @ (formula_to_tokenList f2) @ [T_And, T_RParen]
    | F_Or (f1, f2) => [T_LParen] @ (formula_to_tokenList f1) @ (formula_to_tokenList f2) @ [T_Or, T_RParen]


(* The datatype representing a parse tree. *)
(* - The datatype representing a parse tree of the P non-terminal. *) 
datatype p_pt =
   P_P1 of string        (*  P -> var    *)
 | P_P2 of p_pt * z_pt   (*  P -> ( P Z  *)
(* - The datatype representing a parse tree of the Z non-terminal. *) 
and z_pt =
   Z_Z1                  (*  Z -> ! )    *)
 | Z_Z2 of p_pt * y_pt   (*  Z -> P Y    *)
(* - The datatype representing a parse tree of the Y non-terminal. *) 
and y_pt =
   Y_Y1                  (*  Y -> & )    *)
 | Y_Y2                  (*  Y -> | )    *)


(* Compare parse trees for equality. *)
fun parseTree_equal (p1, p2) =
   let
      fun pEqual (p1, p2) =
         case (p1, p2) of
            (P_P1 s1, P_P1 s2) => s1 = s2
          | (P_P2 (p1, z1), P_P2 (p2, z2)) => pEqual (p1, p2) andalso zEqual (z1, z2)
          | _ => false
      and zEqual (z1, z2) =
         case (z1, z2) of
            (Z_Z1, Z_Z1) => true
          | (Z_Z2 (p1, y1), Z_Z2 (p2, y2)) => pEqual (p1, p2) andalso yEqual (y1, y2)
          | _ => false
      and yEqual (y1, y2) =
         case (y1, y2) of
            (Y_Y1, Y_Y1) => true
          | (Y_Y2, Y_Y2) => true
          | _ => false
   in
      pEqual (p1, p2)
   end
   

(* The following implements a scanner; it converts a list of
 * characters to a list of tokens.  If scanning succeeds, the function
 * returns "SOME ts" (where ts is the list of tokens); if scanning
 * fails, the function returns "NONE".
 *)
fun charList_to_tokenList (cs: char list) : tok list option =
   let
      fun scanTok cs =
         case cs of
            [] => SOME []
          | #"("::cs' => (case scanTok cs' of
                             SOME ts => SOME (T_LParen::ts)
                           | NONE => NONE)
          | #")"::cs' => (case scanTok cs' of
                             SOME ts => SOME (T_RParen::ts)
                           | NONE => NONE)
          | #"&"::cs' => (case scanTok cs' of
                             SOME ts => SOME (T_And::ts)
                           | NONE => NONE)
          | #"|"::cs' => (case scanTok cs' of
                             SOME ts => SOME (T_Or::ts)
                           | NONE => NONE)
          | #"!"::cs' => (case scanTok cs' of
                             SOME ts => SOME (T_Not::ts)
                           | NONE => NONE)
          | c::cs' => if Char.isSpace c
                         then scanTok cs'
                      else if Char.isAlpha c
                         then (case scanVar cs of
                                  SOME (v, cs'') =>
                                     (case scanTok cs'' of
                                         SOME ts => SOME ((T_Var v)::ts)
                                       | NONE => NONE)
                                | NONE => NONE)
                      else NONE
and scanVar cs =
   case cs of
      [] => SOME ("", cs)
    | c::cs' =>
         if Char.isAlpha c
            then (case scanVar cs' of
                     SOME (v, cs'') => SOME ((str c) ^ v, cs'')
                   | NONE => NONE)
            else SOME ("", cs)
   in
      scanTok cs
   end

(* The following implements a scanner; it converts a string to a
 * list of tokens.  If scanning succeeds, the function returns
 * "SOME ts" (where ts is the list of tokens); if scanning fails,
 * the function returns "NONE".  
 *)
fun string_to_tokenList (s: string) : tok list option =
   charList_to_tokenList (explode s)
   

(* DEFINE tokenList_to_parseTree HERE. *)
(* tokenList_to_parseTree : tok list -> p_pt option *)
fun tokenList_to_parseTree ts = 
	let
		fun parseY (ts : tok list) : (y_pt * tok list) option = 
			case ts of
				T_And::ts1' => 
					(case ts1' of 
						T_RParen::ts2' => SOME (Y_Y1, ts2')
						| _ => NONE)
				| T_Or::ts1' =>
					(case ts1' of 
						T_RParen::ts2' => SOME (Y_Y2, ts2')
						| _ => NONE)
				| _ => NONE				

(*T_Var(s)::ts' => SOME (Y_Y1, ts')*)
(* some dead code left over from old stuff*)
(*SOME (Z_Z1, [T_RParen])*)

		and parseZ (ts : tok list) : (z_pt * tok list) option = 
			case ts of 
				T_Not::ts1' => 
					(case ts1' of 
						T_RParen::ts2' => SOME (Z_Z1, ts2')
						| _ => NONE)
				| _ => 
					(case parseP ts of
						SOME (pt, ts1') => 
							(case parseY ts1' of 
								SOME (yt, ts2') => SOME (Z_Z2 (pt, yt), ts2') (* here is the result *)
								| _ => NONE)
						| _ => NONE)

		and parseP (ts : tok list) : (p_pt * tok list) option = 
			case ts of 
				T_Var(s)::ts' => SOME ((P_P1 s), ts') (* adding a list to the end of sum to make the tuple works... *)
				| T_LParen::ts' => (case parseP ts' of
							SOME (pt, ts1') => (case parseZ ts1' of 
								SOME (zt, ts2') => SOME (P_P2 (pt, zt), ts2') (* here is the result... *)
								| _ => NONE)
							| _ => NONE)
				| _ => NONE
	in
		(* Need to check the token list returned from the result of this function *)
		case parseP (ts) of
			SOME (pt, []) => SOME pt
			| _ => NONE
	end


(* DEFINE parseTree_to_formula HERE. *)
(* parseTree_to_formula : p_pt -> fmla *)
fun parseTree_to_formula pt = 
	case pt of
		P_P1 (s) => F_Var (s)
		| P_P2 (pt', zt') => (case zt' of 
			Z_Z1 => F_Not (parseTree_to_formula pt')
			| Z_Z2 (pt2', yt') => (case yt' of
				Y_Y1 => F_And ((parseTree_to_formula pt'), (parseTree_to_formula pt2'))
				| Y_Y2 => F_Or ((parseTree_to_formula pt'), (parseTree_to_formula pt2'))))
		(*
		T_LParen::(parseTree_to_formula pt')::(case zt' of
			Z_Z1 => F_Not (*T_Not::T_RParen*)
			| Z_Z2 (pt2', yt') => (parseTree_to_formula pt2')::(case yt' of
				Y_Y1 => F_And (*T_And::T_RParen*)
				| Y_Y2 => T_Or::T_RParen))*)
		(*| Z_Z1 => T_Not::T_RParen
		| Z_Z2 (pt', yt') => (parseTree_to_formula pt')::(case yt' of
			Y_Y1 => T_And::T_RParen
			| Y_Y2 => T_Or::T_RParen)
		| Y_Y1 => T_And::T_RParen
		| Y_Y2 => T_Or::T_RParen*)

(* break it up into cases for each one, and then simply do a find/replace on all of the symbols *)

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
fun bool_equal (b1: bool, b2: bool) = b1 = b2
fun option_equal elem_equal = fn (NONE, NONE) => true
                               | (SOME x1, SOME x2) => elem_equal (x1, x2)
                               | _ => false
fun list_equal_as_set elem_equal (l1, l2) =
   (length l1) = (length l2)
   andalso
   List.all (fn x => List.exists (fn y => elem_equal (x, y)) l2) l1
   andalso
   List.all (fn x => List.exists (fn y => elem_equal (x, y)) l1) l2
fun list_drop_nth (l, n) =
   (List.take (l, n)) @ (List.drop (l, n+1))

val _ = print "Running tests...\n"

(* Test formulas *)
val f01 = F_And (F_Not (F_Not (F_Or (F_Or (F_Or (F_Not (F_And (F_And (F_Or (F_Or (F_Var "d", F_Var "h"), F_Not (F_Var "a")), F_Var "h"), F_And (F_Not (F_Var "e"), F_Var "b"))), F_Var "g"), F_And (F_Var "c", F_Var "b")), F_Or (F_And (F_Or (F_Var "h", F_Or (F_Or (F_Var "c", F_Var "a"), F_Var "d")), F_Var "h"), F_Or (F_And (F_And (F_Var "b", F_Var "c"), F_Var "f"), F_Var "a"))))), F_Var "b")
val f02 = F_Or (F_And (F_Var "c", F_Or (F_And (F_Not (F_And (F_Var "g", F_And (F_Var "a", F_Or (F_Or (F_Or (F_Not (F_Var "a"), F_Or (F_Var "h", F_Var "b")), F_And (F_Var "d", F_Or (F_Var "a", F_Or (F_Var "c", F_Var "d")))), F_Not (F_Var "d"))))), F_Or (F_Var "a", F_Var "b")), F_Var "b")), F_Not (F_Var "b"))
val f03 = F_And (F_Var "h", F_And (F_Or (F_Var "b", F_And (F_Or (F_Or (F_Or (F_Var "f", F_Not (F_Var "e")), F_Not (F_Not (F_And (F_Var "c", F_Not (F_Not (F_And (F_Var "f", F_Var "d"))))))), F_Var "e"), F_Not (F_Var "f"))), F_Var "b"))
val f04 = F_Or (F_Var "a", F_Not (F_And (F_Var "f", F_Not (F_Or (F_Or (F_And (F_Or (F_Var "g", F_Var "g"), F_Var "a"), F_Or (F_Var "d", F_And (F_And (F_Not (F_Or (F_Var "g", F_And (F_Var "f", F_Not (F_Or (F_Or (F_Var "d", F_Not (F_Not (F_Var "b"))), F_And (F_Not (F_And (F_Var "b", F_And (F_Var "g", F_And (F_Not (F_Var "e"), F_Or (F_Or (F_Or (F_Var "d", F_Or (F_Var "a", F_And (F_And (F_Var "g", F_Var "f"), F_Var "b"))), F_Not (F_Var "c")), F_And (F_Or (F_And (F_And (F_Or (F_Not (F_Var "f"), F_Var "h"), F_Or (F_Var "f", F_And (F_And (F_Not (F_Or (F_And (F_Or (F_Not (F_Var "a"), F_Var "g"), F_Or (F_Not (F_And (F_And (F_And (F_Not (F_Or (F_And (F_Var "h", F_And (F_Var "b", F_Or (F_Not (F_Var "d"), F_Var "d"))), F_Var "a")), F_Not (F_Var "a")), F_Var "d"), F_Or (F_Var "a", F_Not (F_Var "d")))), F_And (F_Var "a", F_Var "f"))), F_Var "h")), F_And (F_Var "c", F_Var "d")), F_Or (F_Var "b", F_Or (F_Var "d", F_Var "f"))))), F_Not (F_Not (F_Var "b"))), F_Not (F_Var "h")), F_Var "d")))))), F_Or (F_Not (F_Var "e"), F_Not (F_Or (F_Var "f", F_Var "d"))))))))), F_Var "d"), F_Or (F_Var "g", F_And (F_Var "b", F_Var "e"))))), F_Var "f")))))
val f05 = F_And (F_Var "a", F_And (F_Not (F_Or (F_Var "c", F_And (F_Var "f", F_Or (F_Var "e", F_And (F_And (F_And (F_Var "b", F_Not (F_And (F_Var "g", F_Var "e"))), F_Or (F_Or (F_Var "e", F_Var "f"), F_Or (F_Var "e", F_Var "f"))), F_Not (F_Var "f")))))), F_Not (F_Var "f")))
val f06 = F_Not (F_And (F_Not (F_And (F_Var "d", F_Var "c")), F_And (F_Var "g", F_Not (F_Or (F_Var "d", F_Or (F_And (F_And (F_Var "d", F_And (F_Not (F_Not (F_Var "f")), F_Var "c")), F_Var "c"), F_Var "h"))))))
val f07 = F_Not (F_Not (F_Not (F_Var "d")))
val f08 = F_Or (F_Var "a", F_Or (F_Var "f", F_Not (F_Not (F_Not (F_Not (F_Or (F_Not (F_Var "f"), F_And (F_Var "c", F_Or (F_Not (F_Or (F_Var "d", F_Not (F_Not (F_Not (F_Or (F_And (F_Var "g", F_And (F_Or (F_Var "h", F_And (F_Not (F_Var "g"), F_And (F_Var "b", F_Not (F_Var "b")))), F_Var "d")), F_Var "b")))))), F_And (F_Var "b", F_Var "b"))))))))))
val f09 = F_Or (F_Not (F_Var "f"), F_Not (F_Not (F_And (F_And (F_Not (F_Or (F_Or (F_Or (F_Or (F_Var "a", F_Not (F_Var "g")), F_Var "h"), F_Var "g"), F_And (F_Var "a", F_Var "f"))), F_Not (F_Var "g")), F_Var "a"))))
val f10 = F_And (F_Not (F_And (F_Not (F_And (F_Var "d", F_And (F_Or (F_Var "c", F_Or (F_Not (F_And (F_Not (F_Var "a"), F_And (F_Var "a", F_Var "f"))), F_Var "b")), F_Var "a"))), F_Not (F_Or (F_And (F_Or (F_Var "c", F_And (F_Var "d", F_Not (F_Not (F_And (F_Or (F_And (F_Or (F_Or (F_Or (F_Var "a", F_And (F_Var "h", F_Var "e")), F_And (F_And (F_Var "g", F_Var "e"), F_Var "d")), F_And (F_Var "c", F_Var "c")), F_Var "a"), F_Var "h"), F_Not (F_Var "g")))))), F_Not (F_Var "f")), F_Not (F_Var "h"))))), F_Var "b")
val f11 = F_Or (F_Or (F_Var "h", F_Var "e"), F_Or (F_Var "b", F_And (F_Var "c", F_Var "a")))
val f12 = F_Not (F_And (F_And (F_Var "d", F_And (F_And (F_Var "e", F_Or (F_Not (F_Or (F_Var "g", F_Var "e")), F_Or (F_Var "d", F_Var "f"))), F_And (F_Var "c", F_And (F_Var "g", F_And (F_Var "c", F_Not (F_Var "d")))))), F_Var "c"))
val f13 = F_Not (F_Not (F_Var "h"))
val f14 = F_Or (F_Not (F_Var "d"), F_Not (F_Var "d"))
val f15 = F_Not (F_And (F_Or (F_And (F_Not (F_Var "e"), F_Not (F_Or (F_Not (F_Var "f"), F_Or (F_Var "a", F_Or (F_Var "h", F_Var "d"))))), F_Var "g"), F_Var "g"))
val f16 = F_Or (F_Var "h", F_Not (F_And (F_And (F_Not (F_Or (F_Var "g", F_And (F_Not (F_Var "c"), F_Not (F_Not (F_And (F_Or (F_And (F_Not (F_And (F_And (F_Var "g", F_Var "b"), F_Var "b")), F_Var "d"), F_Not (F_Or (F_And (F_Var "b", F_Or (F_And (F_Var "c", F_Var "b"), F_Not (F_And (F_Or (F_Var "c", F_Var "g"), F_Or (F_Or (F_And (F_Var "e", F_Or (F_Var "d", F_And (F_Var "b", F_Or (F_Not (F_Not (F_Not (F_Not (F_Var "b")))), F_And (F_Not (F_Not (F_Or (F_And (F_Not (F_And (F_Var "e", F_Var "b")), F_Not (F_Not (F_Var "h"))), F_Var "h"))), F_Var "g"))))), F_Var "e"), F_Or (F_And (F_Or (F_Not (F_Var "f"), F_And (F_Or (F_Var "c", F_Var "g"), F_Var "f")), F_Var "g"), F_And (F_Not (F_Var "d"), F_Var "d"))))))), F_Var "d"))), F_Var "h")))))), F_Var "f"), F_And (F_Not (F_Var "e"), F_Var "h"))))
val f17 = F_Or (F_Not (F_Not (F_Not (F_Or (F_Or (F_And (F_Var "h", F_And (F_Not (F_Not (F_Var "d")), F_Var "b")), F_Or (F_Not (F_Var "b"), F_Var "f")), F_Or (F_Or (F_Var "h", F_Var "b"), F_And (F_Or (F_And (F_Not (F_Or (F_Var "a", F_Var "f")), F_Not (F_Or (F_Var "a", F_And (F_Var "h", F_Var "a")))), F_Var "d"), F_Not (F_Or (F_Not (F_Not (F_Or (F_And (F_And (F_And (F_Var "b", F_Or (F_And (F_Or (F_Var "c", F_Not (F_Var "f")), F_Or (F_And (F_Var "g", F_Not (F_Var "a")), F_Var "c")), F_Var "g")), F_Var "b"), F_Not (F_And (F_Var "h", F_Not (F_And (F_Var "c", F_Not (F_Not (F_And (F_Or (F_Var "d", F_Var "b"), F_Not (F_Not (F_Var "f")))))))))), F_Var "a"))), F_And (F_Not (F_Not (F_Var "h")), F_And (F_Var "b", F_Not (F_Var "d"))))))))))), F_Not (F_And (F_Var "e", F_Var "b")))
val f18 = F_And (F_Or (F_Var "a", F_Or (F_Not (F_Or (F_And (F_Not (F_Not (F_Var "h")), F_And (F_Not (F_Var "d"), F_Or (F_And (F_Or (F_Or (F_Var "d", F_Not (F_Var "b")), F_Or (F_Not (F_Var "b"), F_And (F_And (F_Var "e", F_Var "e"), F_Or (F_Not (F_Var "d"), F_Var "c")))), F_Not (F_Or (F_And (F_Not (F_Var "d"), F_Not (F_Var "c")), F_Or (F_Var "g", F_And (F_Var "c", F_And (F_Var "f", F_Or (F_Var "a", F_Or (F_Or (F_Var "a", F_Not (F_Var "a")), F_Var "b")))))))), F_Var "e"))), F_Var "h")), F_And (F_Not (F_Var "h"), F_Var "e"))), F_Var "h")
val f19 = F_Or (F_Not (F_Var "f"), F_Not (F_And (F_Var "g", F_Var "d")))
val f20 = F_Or (F_Var "c", F_Or (F_Not (F_Var "a"), F_Var "a"))
val f21 = F_Not (F_And (F_Not (F_Or (F_Var "d", F_And (F_Var "e", F_Or (F_Var "h", F_Var "e")))), F_Or (F_Var "a", F_And (F_Var "f", F_Var "b"))))
val f22 = F_Not (F_And (F_Var "h", F_Or (F_Or (F_Var "b", F_Not (F_And (F_Not (F_And (F_Var "f", F_Not (F_Var "d"))), F_Or (F_Var "a", F_Not (F_Not (F_Not (F_And (F_Or (F_And (F_Or (F_Var "b", F_Var "h"), F_And (F_And (F_Not (F_Var "e"), F_And (F_Var "g", F_Var "h")), F_Or (F_Var "b", F_Or (F_Or (F_Var "b", F_Not (F_Var "h")), F_Var "b")))), F_Var "b"), F_And (F_Var "b", F_Var "b"))))))))), F_Var "b")))
val f23 = F_Or (F_Not (F_Var "a"), F_And (F_Or (F_Not (F_Or (F_Or (F_Var "e", F_And (F_Var "h", F_Not (F_Var "g"))), F_Var "a")), F_Var "g"), F_Var "c"))
val f24 = F_Or (F_Or (F_Or (F_Not (F_Var "d"), F_Not (F_Var "b")), F_And (F_Var "b", F_Var "e")), F_Var "d")
val f25 = F_Or (F_Not (F_Or (F_And (F_Not (F_Not (F_Var "f")), F_Var "d"), F_Or (F_Or (F_Var "e", F_Not (F_Or (F_Or (F_And (F_Var "g", F_Var "g"), F_Not (F_And (F_Var "g", F_Not (F_Var "c")))), F_And (F_Var "c", F_Or (F_And (F_Not (F_Not (F_Not (F_Not (F_Not (F_Var "g"))))), F_Or (F_And (F_And (F_Or (F_And (F_Var "b", F_And (F_And (F_And (F_Var "h", F_Or (F_Var "g", F_Var "d")), F_Or (F_Var "c", F_Not (F_Var "e"))), F_Or (F_Var "g", F_Var "g"))), F_Var "a"), F_Not (F_And (F_Var "a", F_Var "e"))), F_Var "h"), F_Var "e")), F_Var "g"))))), F_Not (F_Or (F_Var "e", F_Not (F_Not (F_Var "h"))))))), F_Not (F_Var "e"))
val f26 = F_Not (F_Var "d")
val f27 = F_Or (F_Var "a", F_Not (F_Not (F_Not (F_And (F_Var "e", F_Var "h")))))
val f28 = F_Or (F_Or (F_Not (F_Var "a"), F_Var "a"), F_Or (F_Or (F_Var "h", F_Not (F_And (F_Var "b", F_Or (F_And (F_And (F_And (F_And (F_Var "a", F_Not (F_Not (F_Or (F_Or (F_Var "b", F_Var "b"), F_Var "g")))), F_Var "e"), F_And (F_Or (F_Not (F_Not (F_And (F_Or (F_Var "d", F_Var "e"), F_Not (F_Var "e")))), F_Not (F_And (F_Var "e", F_Or (F_Or (F_Var "b", F_Var "a"), F_And (F_Var "f", F_Not (F_Or (F_Var "c", F_Var "e"))))))), F_Var "h")), F_Var "a"), F_And (F_Var "a", F_Var "f"))))), F_Or (F_Var "e", F_And (F_Or (F_And (F_Not (F_Var "g"), F_And (F_Var "g", F_Not (F_Or (F_Var "e", F_And (F_Or (F_Var "g", F_Var "c"), F_Var "g"))))), F_Var "f"), F_Var "a"))))
val f29 = F_Or (F_Not (F_Or (F_Not (F_Not (F_Not (F_And (F_Var "b", F_Not (F_And (F_Not (F_Not (F_Var "b")), F_Or (F_Not (F_Or (F_Var "f", F_And (F_And (F_And (F_Not (F_Not (F_Var "g")), F_Var "g"), F_Not (F_Var "d")), F_Or (F_Or (F_Var "a", F_Or (F_Not (F_And (F_Var "h", F_Or (F_Var "b", F_Var "d"))), F_Var "e")), F_Not (F_Var "a"))))), F_Var "b"))))))), F_Not (F_Var "a"))), F_Var "e")
val f30 = F_And (F_And (F_Var "f", F_Var "f"), F_Not (F_And (F_Not (F_Not (F_Var "a")), F_Var "h")))
val f31 = F_Var "a"
val f32 = F_Or (F_Or (F_Or (F_Var "a", F_Var "a"), F_Not (F_Not (F_Not (F_And (F_Or (F_Not (F_Not (F_Not (F_And (F_Not (F_Var "d"), F_Not (F_Var "d"))))), F_Var "c"), F_Not (F_Not (F_And (F_Not (F_Var "c"), F_And (F_Not (F_Var "c"), F_Not (F_Var "d")))))))))), F_Var "g")
(* Test variable assignments *)
val v01 = fn s => case s of "a" => false | "b" => false | "c" => false | "d" => true | "e" => true | "f" => false | "g" => false | "h" => true | _ => false
val v02 = fn s => case s of "a" => false | "b" => true | "c" => false | "d" => false | "e" => false | "f" => true | "g" => false | "h" => false | _ => false
val v03 = fn s => case s of "a" => true | "b" => false | "c" => true | "d" => false | "e" => false | "f" => false | "g" => true | "h" => false | _ => false
val v04 = fn s => case s of "a" => true | "b" => true | "c" => true | "d" => true | "e" => true | "f" => true | "g" => false | "h" => false | _ => false
(* Test token lists (parse succeeds) *)
val ts01 = formula_to_tokenList f01
val ts02 = formula_to_tokenList f02
val ts03 = formula_to_tokenList f03
val ts04 = formula_to_tokenList f04
val ts05 = formula_to_tokenList f05
val ts06 = formula_to_tokenList f06
val ts07 = formula_to_tokenList f07
val ts08 = formula_to_tokenList f08
val ts09 = formula_to_tokenList f09
val ts10 = formula_to_tokenList f10
val ts11 = formula_to_tokenList f11
val ts12 = formula_to_tokenList f12
val ts13 = formula_to_tokenList f13
val ts14 = formula_to_tokenList f14
val ts15 = formula_to_tokenList f15
val ts16 = formula_to_tokenList f16
val ts17 = formula_to_tokenList f17
val ts18 = formula_to_tokenList f18
val ts19 = formula_to_tokenList f19
val ts20 = formula_to_tokenList f20
val ts21 = formula_to_tokenList f21
val ts22 = formula_to_tokenList f22
val ts23 = formula_to_tokenList f23
val ts24 = formula_to_tokenList f24
val ts25 = formula_to_tokenList f25
val ts26 = formula_to_tokenList f26
val ts27 = formula_to_tokenList f27
val ts28 = formula_to_tokenList f28
val ts29 = formula_to_tokenList f29
val ts30 = formula_to_tokenList f30
val ts31 = formula_to_tokenList f31
val ts32 = formula_to_tokenList f32
(* Test token lists (parse fails) *)
val ts01x = list_drop_nth (ts01, 56)
val ts02x = list_drop_nth (ts02, 21)
val ts03x = list_drop_nth (ts03, 18)
val ts04x = list_drop_nth (ts04, 139)
val ts05x = list_drop_nth (ts05, 58)
val ts06x = list_drop_nth (ts06, 39)
val ts07x = list_drop_nth (ts07, 5)
val ts08x = list_drop_nth (ts08, 31)
val ts09x = list_drop_nth (ts09, 48)
val ts10x = list_drop_nth (ts10, 101)
val ts11x = list_drop_nth (ts11, 10)
val ts12x = list_drop_nth (ts12, 19)
val ts13x = list_drop_nth (ts13, 5)
val ts14x = list_drop_nth (ts14, 6)
val ts15x = list_drop_nth (ts15, 35)
val ts16x = list_drop_nth (ts16, 74)
val ts17x = list_drop_nth (ts17, 126)
val ts18x = list_drop_nth (ts18, 114)
val ts19x = list_drop_nth (ts19, 13)
val ts20x = list_drop_nth (ts20, 2)
val ts21x = list_drop_nth (ts21, 24)
val ts22x = list_drop_nth (ts22, 81)
val ts23x = list_drop_nth (ts23, 21)
val ts24x = list_drop_nth (ts24, 16)
val ts25x = list_drop_nth (ts25, 81)
val ts26x = list_drop_nth (ts26, 3)
val ts27x = list_drop_nth (ts27, 5)
val ts28x = list_drop_nth (ts28, 1)
val ts29x = list_drop_nth (ts29, 33)
val ts30x = list_drop_nth (ts30, 0)
val ts31x = list_drop_nth (ts31, 0)
val ts32x = list_drop_nth (ts32, 23)
(* Test parse trees *)
val p01 = P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P1 "h", Y_Y2)), Z_Z2 (P_P2 (P_P1 "a", Z_Z1), Y_Y2)), Z_Z2 (P_P1 "h", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z1), Z_Z2 (P_P1 "b", Y_Y1)), Y_Y1)), Z_Z1), Z_Z2 (P_P1 "g", Y_Y2)), Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "b", Y_Y1)), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "a", Y_Y2)), Z_Z2 (P_P1 "d", Y_Y2)), Y_Y2)), Z_Z2 (P_P1 "h", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "c", Y_Y1)), Z_Z2 (P_P1 "f", Y_Y1)), Z_Z2 (P_P1 "a", Y_Y2)), Y_Y2)), Y_Y2)), Z_Z1), Z_Z1), Z_Z2 (P_P1 "b", Y_Y1))
val p02 = P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z1), Z_Z2 (P_P2 (P_P1 "h", Z_Z2 (P_P1 "b", Y_Y2)), Y_Y2)), Z_Z2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "d", Y_Y2)), Y_Y2)), Y_Y1)), Y_Y2)), Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y2)), Y_Y1)), Y_Y1)), Z_Z1), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P1 "b", Y_Y2)), Y_Y1)), Z_Z2 (P_P1 "b", Y_Y2)), Y_Y1)), Z_Z2 (P_P2 (P_P1 "b", Z_Z1), Y_Y2))
val p03 = P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P1 "e", Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z2 (P_P1 "d", Y_Y1)), Z_Z1), Z_Z1), Y_Y1)), Z_Z1), Z_Z1), Y_Y2)), Z_Z2 (P_P1 "e", Y_Y2)), Z_Z2 (P_P2 (P_P1 "f", Z_Z1), Y_Y1)), Y_Y2)), Z_Z2 (P_P1 "b", Y_Y1)), Y_Y1))
val p04 = P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "g", Y_Y2)), Z_Z2 (P_P1 "a", Y_Y1)), Z_Z2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z1), Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "f", Y_Y1)), Z_Z2 (P_P1 "b", Y_Y1)), Y_Y2)), Y_Y2)), Z_Z2 (P_P2 (P_P1 "c", Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z2 (P_P1 "h", Y_Y2)), Z_Z2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z1), Z_Z2 (P_P1 "g", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z2 (P_P1 "d", Y_Y2)), Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "a", Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P1 "a", Z_Z1), Y_Y1)), Z_Z2 (P_P1 "d", Y_Y1)), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y2)), Y_Y1)), Z_Z1), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P1 "f", Y_Y1)), Y_Y2)), Y_Y1)), Z_Z2 (P_P1 "h", Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "d", Y_Y1)), Y_Y1)), Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P1 "d", Z_Z2 (P_P1 "f", Y_Y2)), Y_Y2)), Y_Y1)), Y_Y2)), Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z1), Z_Z1), Y_Y1)), Z_Z2 (P_P2 (P_P1 "h", Z_Z1), Y_Y2)), Z_Z2 (P_P1 "d", Y_Y1)), Y_Y2)), Y_Y1)), Y_Y1)), Y_Y1)), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "f", Z_Z2 (P_P1 "d", Y_Y2)), Z_Z1), Y_Y2)), Y_Y1)), Y_Y2)), Z_Z1), Y_Y1)), Y_Y2)), Z_Z1), Z_Z2 (P_P1 "d", Y_Y1)), Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "e", Y_Y1)), Y_Y2)), Y_Y1)), Y_Y2)), Y_Y2)), Z_Z2 (P_P1 "f", Y_Y2)), Z_Z1), Y_Y1)), Z_Z1), Y_Y2))
val p05 = P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "e", Y_Y1)), Z_Z1), Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P1 "f", Y_Y2)), Z_Z2 (P_P2 (P_P1 "e", Z_Z2 (P_P1 "f", Y_Y2)), Y_Y2)), Y_Y1)), Z_Z2 (P_P2 (P_P1 "f", Z_Z1), Y_Y1)), Y_Y2)), Y_Y1)), Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P1 "f", Z_Z1), Y_Y1)), Y_Y1))
val p06 = P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P1 "c", Y_Y1)), Z_Z1), Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z1), Z_Z2 (P_P1 "c", Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "c", Y_Y1)), Z_Z2 (P_P1 "h", Y_Y2)), Y_Y2)), Z_Z1), Y_Y1)), Y_Y1)), Z_Z1)
val p07 = P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z1), Z_Z1)
val p08 = P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P2 (P_P1 "g", Z_Z1), Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P1 "b", Z_Z1), Y_Y1)), Y_Y1)), Y_Y2)), Z_Z2 (P_P1 "d", Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "b", Y_Y2)), Z_Z1), Z_Z1), Z_Z1), Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "b", Y_Y1)), Y_Y2)), Y_Y1)), Y_Y2)), Z_Z1), Z_Z1), Z_Z1), Z_Z1), Y_Y2)), Y_Y2))
val p09 = P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "g", Z_Z1), Y_Y2)), Z_Z2 (P_P1 "h", Y_Y2)), Z_Z2 (P_P1 "g", Y_Y2)), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P1 "f", Y_Y1)), Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P1 "g", Z_Z1), Y_Y1)), Z_Z2 (P_P1 "a", Y_Y1)), Z_Z1), Z_Z1), Y_Y2))
val p10 = P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z1), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P1 "f", Y_Y1)), Y_Y1)), Z_Z1), Z_Z2 (P_P1 "b", Y_Y2)), Y_Y2)), Z_Z2 (P_P1 "a", Y_Y1)), Y_Y1)), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "h", Z_Z2 (P_P1 "e", Y_Y1)), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "e", Y_Y1)), Z_Z2 (P_P1 "d", Y_Y1)), Y_Y2)), Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "c", Y_Y1)), Y_Y2)), Z_Z2 (P_P1 "a", Y_Y1)), Z_Z2 (P_P1 "h", Y_Y2)), Z_Z2 (P_P2 (P_P1 "g", Z_Z1), Y_Y1)), Z_Z1), Z_Z1), Y_Y1)), Y_Y2)), Z_Z2 (P_P2 (P_P1 "f", Z_Z1), Y_Y1)), Z_Z2 (P_P2 (P_P1 "h", Z_Z1), Y_Y2)), Z_Z1), Y_Y1)), Z_Z1), Z_Z2 (P_P1 "b", Y_Y1))
val p11 = P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P1 "e", Y_Y2)), Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "a", Y_Y1)), Y_Y2)), Y_Y2))
val p12 = P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "e", Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P1 "d", Z_Z2 (P_P1 "f", Y_Y2)), Y_Y2)), Y_Y1)), Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y1)), Y_Y1)), Y_Y1)), Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "c", Y_Y1)), Z_Z1)
val p13 = P_P2 (P_P2 (P_P1 "h", Z_Z1), Z_Z1)
val p14 = P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y2))
val p15 = P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "e", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "h", Z_Z2 (P_P1 "d", Y_Y2)), Y_Y2)), Y_Y2)), Z_Z1), Y_Y1)), Z_Z2 (P_P1 "g", Y_Y2)), Z_Z2 (P_P1 "g", Y_Y1)), Z_Z1)
val p16 = P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P2 (P_P1 "c", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "b", Y_Y1)), Z_Z2 (P_P1 "b", Y_Y1)), Z_Z1), Z_Z2 (P_P1 "d", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "b", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "g", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z1), Z_Z1), Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P1 "b", Y_Y1)), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "h", Z_Z1), Z_Z1), Y_Y1)), Z_Z2 (P_P1 "h", Y_Y2)), Z_Z1), Z_Z1), Z_Z2 (P_P1 "g", Y_Y1)), Y_Y2)), Y_Y1)), Y_Y2)), Y_Y1)), Z_Z2 (P_P1 "e", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "g", Y_Y2)), Z_Z2 (P_P1 "f", Y_Y1)), Y_Y2)), Z_Z2 (P_P1 "g", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z2 (P_P1 "d", Y_Y1)), Y_Y2)), Y_Y2)), Y_Y1)), Z_Z1), Y_Y2)), Y_Y1)), Z_Z2 (P_P1 "d", Y_Y2)), Z_Z1), Y_Y2)), Z_Z2 (P_P1 "h", Y_Y1)), Z_Z1), Z_Z1), Y_Y1)), Y_Y2)), Z_Z1), Z_Z2 (P_P1 "f", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z1), Z_Z2 (P_P1 "h", Y_Y1)), Y_Y1)), Z_Z1), Y_Y2))
val p17 = P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z1), Z_Z2 (P_P1 "b", Y_Y1)), Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z1), Z_Z2 (P_P1 "f", Y_Y2)), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P1 "b", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P1 "f", Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "h", Z_Z2 (P_P1 "a", Y_Y1)), Y_Y2)), Z_Z1), Y_Y1)), Z_Z2 (P_P1 "d", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P1 "f", Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P1 "a", Z_Z1), Y_Y1)), Z_Z2 (P_P1 "c", Y_Y2)), Y_Y1)), Z_Z2 (P_P1 "g", Y_Y2)), Y_Y1)), Z_Z2 (P_P1 "b", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P1 "b", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z1), Y_Y1)), Z_Z1), Z_Z1), Y_Y1)), Z_Z1), Y_Y1)), Z_Z1), Y_Y1)), Z_Z2 (P_P1 "a", Y_Y2)), Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "h", Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y1)), Y_Y1)), Y_Y2)), Z_Z1), Y_Y1)), Y_Y2)), Y_Y2)), Z_Z1), Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P1 "b", Y_Y1)), Z_Z1), Y_Y2))
val p18 = P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "h", Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P1 "b", Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P1 "e", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z2 (P_P1 "c", Y_Y2)), Y_Y1)), Y_Y2)), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z2 (P_P2 (P_P1 "c", Z_Z1), Y_Y1)), Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "a", Z_Z1), Y_Y2)), Z_Z2 (P_P1 "b", Y_Y2)), Y_Y2)), Y_Y1)), Y_Y1)), Y_Y2)), Y_Y2)), Z_Z1), Y_Y1)), Z_Z2 (P_P1 "e", Y_Y2)), Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "h", Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "h", Z_Z1), Z_Z2 (P_P1 "e", Y_Y1)), Y_Y2)), Y_Y2)), Z_Z2 (P_P1 "h", Y_Y1))
val p19 = P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "d", Y_Y1)), Z_Z1), Y_Y2))
val p20 = P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P2 (P_P1 "a", Z_Z1), Z_Z2 (P_P1 "a", Y_Y2)), Y_Y2))
val p21 = P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P1 "h", Z_Z2 (P_P1 "e", Y_Y2)), Y_Y1)), Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P1 "f", Z_Z2 (P_P1 "b", Y_Y1)), Y_Y2)), Y_Y1)), Z_Z1)
val p22 = P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y1)), Z_Z1), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "h", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "e", Z_Z1), Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "h", Y_Y1)), Y_Y1)), Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P1 "h", Z_Z1), Y_Y2)), Z_Z2 (P_P1 "b", Y_Y2)), Y_Y2)), Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "b", Y_Y2)), Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "b", Y_Y1)), Y_Y1)), Z_Z1), Z_Z1), Z_Z1), Y_Y2)), Y_Y1)), Z_Z1), Y_Y2)), Z_Z2 (P_P1 "b", Y_Y2)), Y_Y1)), Z_Z1)
val p23 = P_P2 (P_P2 (P_P1 "a", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P1 "g", Z_Z1), Y_Y1)), Y_Y2)), Z_Z2 (P_P1 "a", Y_Y2)), Z_Z1), Z_Z2 (P_P1 "g", Y_Y2)), Z_Z2 (P_P1 "c", Y_Y1)), Y_Y2))
val p24 = P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z2 (P_P2 (P_P1 "b", Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "e", Y_Y1)), Y_Y2)), Z_Z2 (P_P1 "d", Y_Y2))
val p25 = P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z1), Z_Z1), Z_Z2 (P_P1 "d", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "g", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P1 "c", Z_Z1), Y_Y1)), Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z1), Z_Z1), Z_Z1), Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "d", Y_Y2)), Y_Y1)), Z_Z2 (P_P2 (P_P1 "c", Z_Z2 (P_P2 (P_P1 "e", Z_Z1), Y_Y2)), Y_Y1)), Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "g", Y_Y2)), Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "a", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P1 "e", Y_Y1)), Z_Z1), Y_Y1)), Z_Z2 (P_P1 "h", Y_Y1)), Z_Z2 (P_P1 "e", Y_Y2)), Y_Y1)), Z_Z2 (P_P1 "g", Y_Y2)), Y_Y1)), Y_Y2)), Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P2 (P_P1 "h", Z_Z1), Z_Z1), Y_Y2)), Z_Z1), Y_Y2)), Y_Y2)), Z_Z1), Z_Z2 (P_P2 (P_P1 "e", Z_Z1), Y_Y2))
val p26 = P_P2 (P_P1 "d", Z_Z1)
val p27 = P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P1 "h", Y_Y1)), Z_Z1), Z_Z1), Z_Z1), Y_Y2))
val p28 = P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z1), Z_Z2 (P_P1 "a", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "b", Y_Y2)), Z_Z2 (P_P1 "g", Y_Y2)), Z_Z1), Z_Z1), Y_Y1)), Z_Z2 (P_P1 "e", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z2 (P_P1 "e", Y_Y2)), Z_Z2 (P_P2 (P_P1 "e", Z_Z1), Y_Y1)), Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "a", Y_Y2)), Z_Z2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P2 (P_P1 "c", Z_Z2 (P_P1 "e", Y_Y2)), Z_Z1), Y_Y1)), Y_Y2)), Y_Y1)), Z_Z1), Y_Y2)), Z_Z2 (P_P1 "h", Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "a", Y_Y1)), Z_Z2 (P_P2 (P_P1 "a", Z_Z2 (P_P1 "f", Y_Y1)), Y_Y2)), Y_Y1)), Z_Z1), Y_Y2)), Z_Z2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z1), Z_Z2 (P_P2 (P_P1 "g", Z_Z2 (P_P2 (P_P2 (P_P1 "e", Z_Z2 (P_P2 (P_P2 (P_P1 "g", Z_Z2 (P_P1 "c", Y_Y2)), Z_Z2 (P_P1 "g", Y_Y1)), Y_Y2)), Z_Z1), Y_Y1)), Y_Y1)), Z_Z2 (P_P1 "f", Y_Y2)), Z_Z2 (P_P1 "a", Y_Y1)), Y_Y2)), Y_Y2)), Y_Y2))
val p29 = P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "b", Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "f", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "g", Z_Z1), Z_Z1), Z_Z2 (P_P1 "g", Y_Y1)), Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P2 (P_P2 (P_P2 (P_P1 "h", Z_Z2 (P_P2 (P_P1 "b", Z_Z2 (P_P1 "d", Y_Y2)), Y_Y1)), Z_Z1), Z_Z2 (P_P1 "e", Y_Y2)), Y_Y2)), Z_Z2 (P_P2 (P_P1 "a", Z_Z1), Y_Y2)), Y_Y1)), Y_Y2)), Z_Z1), Z_Z2 (P_P1 "b", Y_Y2)), Y_Y1)), Z_Z1), Y_Y1)), Z_Z1), Z_Z1), Z_Z1), Z_Z2 (P_P2 (P_P1 "a", Z_Z1), Y_Y2)), Z_Z1), Z_Z2 (P_P1 "e", Y_Y2))
val p30 = P_P2 (P_P2 (P_P1 "f", Z_Z2 (P_P1 "f", Y_Y1)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z1), Z_Z1), Z_Z2 (P_P1 "h", Y_Y1)), Z_Z1), Y_Y1))
val p31 = P_P1 "a"
val p32 = P_P2 (P_P2 (P_P2 (P_P1 "a", Z_Z2 (P_P1 "a", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "d", Z_Z1), Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y1)), Z_Z1), Z_Z1), Z_Z1), Z_Z2 (P_P1 "c", Y_Y2)), Z_Z2 (P_P2 (P_P2 (P_P2 (P_P2 (P_P1 "c", Z_Z1), Z_Z2 (P_P2 (P_P2 (P_P1 "c", Z_Z1), Z_Z2 (P_P2 (P_P1 "d", Z_Z1), Y_Y1)), Y_Y1)), Z_Z1), Z_Z1), Y_Y1)), Z_Z1), Z_Z1), Z_Z1), Y_Y2)), Z_Z2 (P_P1 "g", Y_Y2))


(* varsOf_formula tests *)
val varsOf_formula_test01 = ("varsOf_formula_test01", f01, ["e","g","d","h","c","f","a","b"])
val varsOf_formula_test02 = ("varsOf_formula_test02", f02, ["g","h","c","d","a","b"])
val varsOf_formula_test03 = ("varsOf_formula_test03", f03, ["h","c","d","e","f","b"])
val varsOf_formula_test04 = ("varsOf_formula_test04", f04, ["a","c","h","d","g","b","e","f"])
val varsOf_formula_test05 = ("varsOf_formula_test05", f05, ["a","c","b","g","e","f"])
val varsOf_formula_test06 = ("varsOf_formula_test06", f06, ["g","d","f","c","h"])
val varsOf_formula_test07 = ("varsOf_formula_test07", f07, ["d"])
val varsOf_formula_test08 = ("varsOf_formula_test08", f08, ["a","f","c","h","g","d","b"])
val varsOf_formula_test09 = ("varsOf_formula_test09", f09, ["h","f","g","a"])
val varsOf_formula_test10 = ("varsOf_formula_test10", f10, ["e","d","c","a","g","f","h","b"])
val varsOf_formula_test11 = ("varsOf_formula_test11", f11, ["h","e","b","c","a"])
val varsOf_formula_test12 = ("varsOf_formula_test12", f12, ["e","f","g","d","c"])
val varsOf_formula_test13 = ("varsOf_formula_test13", f13, ["h"])
val varsOf_formula_test14 = ("varsOf_formula_test14", f14, ["d"])
val varsOf_formula_test15 = ("varsOf_formula_test15", f15, ["e","f","a","h","d","g"])
val varsOf_formula_test16 = ("varsOf_formula_test16", f16, ["b","c","g","d","f","e","h"])
val varsOf_formula_test17 = ("varsOf_formula_test17", f17, ["g","c","f","a","h","d","e","b"])
val varsOf_formula_test18 = ("varsOf_formula_test18", f18, ["d","g","c","f","a","b","e","h"])
val varsOf_formula_test19 = ("varsOf_formula_test19", f19, ["f","g","d"])
val varsOf_formula_test20 = ("varsOf_formula_test20", f20, ["c","a"])
val varsOf_formula_test21 = ("varsOf_formula_test21", f21, ["d","h","e","a","f","b"])
val varsOf_formula_test22 = ("varsOf_formula_test22", f22, ["f","d","a","e","g","h","b"])
val varsOf_formula_test23 = ("varsOf_formula_test23", f23, ["e","h","a","g","c"])
val varsOf_formula_test24 = ("varsOf_formula_test24", f24, ["b","e","d"])
val varsOf_formula_test25 = ("varsOf_formula_test25", f25, ["f","b","d","c","a","g","h","e"])
val varsOf_formula_test26 = ("varsOf_formula_test26", f26, ["d"])
val varsOf_formula_test27 = ("varsOf_formula_test27", f27, ["a","e","h"])
val varsOf_formula_test28 = ("varsOf_formula_test28", f28, ["d","b","h","e","c","g","f","a"])
val varsOf_formula_test29 = ("varsOf_formula_test29", f29, ["f","g","h","d","b","a","e"])
val varsOf_formula_test30 = ("varsOf_formula_test30", f30, ["f","a","h"])
val varsOf_formula_test31 = ("varsOf_formula_test31", f31, ["a"])
val varsOf_formula_test32 = ("varsOf_formula_test32", f32, ["a","c","d","g"])
val varsOf_formula_tests = [varsOf_formula_test01,varsOf_formula_test02,varsOf_formula_test03,varsOf_formula_test04,varsOf_formula_test05,varsOf_formula_test06,varsOf_formula_test07,varsOf_formula_test08,varsOf_formula_test09,varsOf_formula_test10,varsOf_formula_test11,varsOf_formula_test12,varsOf_formula_test13,varsOf_formula_test14,varsOf_formula_test15,varsOf_formula_test16,varsOf_formula_test17,varsOf_formula_test18,varsOf_formula_test19,varsOf_formula_test20,varsOf_formula_test21,varsOf_formula_test22,varsOf_formula_test23,varsOf_formula_test24,varsOf_formula_test25,varsOf_formula_test26,varsOf_formula_test27,varsOf_formula_test28,varsOf_formula_test29,varsOf_formula_test30,varsOf_formula_test31,varsOf_formula_test32]
(* Uncomment the following to test your varsOf_formula function. *)
val _ = run_tests varsOf_formula (list_equal_as_set string_equal) varsOf_formula_tests


(* eval_formula tests *)
val eval_formula_test0101 = ("eval_formula_test0101", (v01, f01), false)
val eval_formula_test0102 = ("eval_formula_test0102", (v02, f01), true)
val eval_formula_test0103 = ("eval_formula_test0103", (v03, f01), false)
val eval_formula_test0104 = ("eval_formula_test0104", (v04, f01), true)
val eval_formula_test0201 = ("eval_formula_test0201", (v01, f02), true)
val eval_formula_test0202 = ("eval_formula_test0202", (v02, f02), false)
val eval_formula_test0203 = ("eval_formula_test0203", (v03, f02), true)
val eval_formula_test0204 = ("eval_formula_test0204", (v04, f02), true)
val eval_formula_test0301 = ("eval_formula_test0301", (v01, f03), false)
val eval_formula_test0302 = ("eval_formula_test0302", (v02, f03), false)
val eval_formula_test0303 = ("eval_formula_test0303", (v03, f03), false)
val eval_formula_test0304 = ("eval_formula_test0304", (v04, f03), false)
val eval_formula_test0401 = ("eval_formula_test0401", (v01, f04), true)
val eval_formula_test0402 = ("eval_formula_test0402", (v02, f04), true)
val eval_formula_test0403 = ("eval_formula_test0403", (v03, f04), true)
val eval_formula_test0404 = ("eval_formula_test0404", (v04, f04), true)
val eval_formula_test0501 = ("eval_formula_test0501", (v01, f05), false)
val eval_formula_test0502 = ("eval_formula_test0502", (v02, f05), false)
val eval_formula_test0503 = ("eval_formula_test0503", (v03, f05), false)
val eval_formula_test0504 = ("eval_formula_test0504", (v04, f05), false)
val eval_formula_test0601 = ("eval_formula_test0601", (v01, f06), true)
val eval_formula_test0602 = ("eval_formula_test0602", (v02, f06), true)
val eval_formula_test0603 = ("eval_formula_test0603", (v03, f06), false)
val eval_formula_test0604 = ("eval_formula_test0604", (v04, f06), true)
val eval_formula_test0701 = ("eval_formula_test0701", (v01, f07), false)
val eval_formula_test0702 = ("eval_formula_test0702", (v02, f07), true)
val eval_formula_test0703 = ("eval_formula_test0703", (v03, f07), true)
val eval_formula_test0704 = ("eval_formula_test0704", (v04, f07), false)
val eval_formula_test0801 = ("eval_formula_test0801", (v01, f08), true)
val eval_formula_test0802 = ("eval_formula_test0802", (v02, f08), true)
val eval_formula_test0803 = ("eval_formula_test0803", (v03, f08), true)
val eval_formula_test0804 = ("eval_formula_test0804", (v04, f08), true)
val eval_formula_test0901 = ("eval_formula_test0901", (v01, f09), true)
val eval_formula_test0902 = ("eval_formula_test0902", (v02, f09), false)
val eval_formula_test0903 = ("eval_formula_test0903", (v03, f09), true)
val eval_formula_test0904 = ("eval_formula_test0904", (v04, f09), false)
val eval_formula_test1001 = ("eval_formula_test1001", (v01, f10), false)
val eval_formula_test1002 = ("eval_formula_test1002", (v02, f10), true)
val eval_formula_test1003 = ("eval_formula_test1003", (v03, f10), false)
val eval_formula_test1004 = ("eval_formula_test1004", (v04, f10), true)
val eval_formula_test1101 = ("eval_formula_test1101", (v01, f11), true)
val eval_formula_test1102 = ("eval_formula_test1102", (v02, f11), true)
val eval_formula_test1103 = ("eval_formula_test1103", (v03, f11), true)
val eval_formula_test1104 = ("eval_formula_test1104", (v04, f11), true)
val eval_formula_test1201 = ("eval_formula_test1201", (v01, f12), true)
val eval_formula_test1202 = ("eval_formula_test1202", (v02, f12), true)
val eval_formula_test1203 = ("eval_formula_test1203", (v03, f12), true)
val eval_formula_test1204 = ("eval_formula_test1204", (v04, f12), true)
val eval_formula_test1301 = ("eval_formula_test1301", (v01, f13), true)
val eval_formula_test1302 = ("eval_formula_test1302", (v02, f13), false)
val eval_formula_test1303 = ("eval_formula_test1303", (v03, f13), false)
val eval_formula_test1304 = ("eval_formula_test1304", (v04, f13), false)
val eval_formula_test1401 = ("eval_formula_test1401", (v01, f14), false)
val eval_formula_test1402 = ("eval_formula_test1402", (v02, f14), true)
val eval_formula_test1403 = ("eval_formula_test1403", (v03, f14), true)
val eval_formula_test1404 = ("eval_formula_test1404", (v04, f14), false)
val eval_formula_test1501 = ("eval_formula_test1501", (v01, f15), true)
val eval_formula_test1502 = ("eval_formula_test1502", (v02, f15), true)
val eval_formula_test1503 = ("eval_formula_test1503", (v03, f15), false)
val eval_formula_test1504 = ("eval_formula_test1504", (v04, f15), true)
val eval_formula_test1601 = ("eval_formula_test1601", (v01, f16), true)
val eval_formula_test1602 = ("eval_formula_test1602", (v02, f16), true)
val eval_formula_test1603 = ("eval_formula_test1603", (v03, f16), true)
val eval_formula_test1604 = ("eval_formula_test1604", (v04, f16), true)
val eval_formula_test1701 = ("eval_formula_test1701", (v01, f17), true)
val eval_formula_test1702 = ("eval_formula_test1702", (v02, f17), true)
val eval_formula_test1703 = ("eval_formula_test1703", (v03, f17), true)
val eval_formula_test1704 = ("eval_formula_test1704", (v04, f17), false)
val eval_formula_test1801 = ("eval_formula_test1801", (v01, f18), false)
val eval_formula_test1802 = ("eval_formula_test1802", (v02, f18), false)
val eval_formula_test1803 = ("eval_formula_test1803", (v03, f18), false)
val eval_formula_test1804 = ("eval_formula_test1804", (v04, f18), false)
val eval_formula_test1901 = ("eval_formula_test1901", (v01, f19), true)
val eval_formula_test1902 = ("eval_formula_test1902", (v02, f19), true)
val eval_formula_test1903 = ("eval_formula_test1903", (v03, f19), true)
val eval_formula_test1904 = ("eval_formula_test1904", (v04, f19), true)
val eval_formula_test2001 = ("eval_formula_test2001", (v01, f20), true)
val eval_formula_test2002 = ("eval_formula_test2002", (v02, f20), true)
val eval_formula_test2003 = ("eval_formula_test2003", (v03, f20), true)
val eval_formula_test2004 = ("eval_formula_test2004", (v04, f20), true)
val eval_formula_test2101 = ("eval_formula_test2101", (v01, f21), true)
val eval_formula_test2102 = ("eval_formula_test2102", (v02, f21), false)
val eval_formula_test2103 = ("eval_formula_test2103", (v03, f21), false)
val eval_formula_test2104 = ("eval_formula_test2104", (v04, f21), true)
val eval_formula_test2201 = ("eval_formula_test2201", (v01, f22), true)
val eval_formula_test2202 = ("eval_formula_test2202", (v02, f22), true)
val eval_formula_test2203 = ("eval_formula_test2203", (v03, f22), true)
val eval_formula_test2204 = ("eval_formula_test2204", (v04, f22), true)
val eval_formula_test2301 = ("eval_formula_test2301", (v01, f23), true)
val eval_formula_test2302 = ("eval_formula_test2302", (v02, f23), true)
val eval_formula_test2303 = ("eval_formula_test2303", (v03, f23), true)
val eval_formula_test2304 = ("eval_formula_test2304", (v04, f23), false)
val eval_formula_test2401 = ("eval_formula_test2401", (v01, f24), true)
val eval_formula_test2402 = ("eval_formula_test2402", (v02, f24), true)
val eval_formula_test2403 = ("eval_formula_test2403", (v03, f24), true)
val eval_formula_test2404 = ("eval_formula_test2404", (v04, f24), true)
val eval_formula_test2501 = ("eval_formula_test2501", (v01, f25), false)
val eval_formula_test2502 = ("eval_formula_test2502", (v02, f25), true)
val eval_formula_test2503 = ("eval_formula_test2503", (v03, f25), true)
val eval_formula_test2504 = ("eval_formula_test2504", (v04, f25), false)
val eval_formula_test2601 = ("eval_formula_test2601", (v01, f26), false)
val eval_formula_test2602 = ("eval_formula_test2602", (v02, f26), true)
val eval_formula_test2603 = ("eval_formula_test2603", (v03, f26), true)
val eval_formula_test2604 = ("eval_formula_test2604", (v04, f26), false)
val eval_formula_test2701 = ("eval_formula_test2701", (v01, f27), false)
val eval_formula_test2702 = ("eval_formula_test2702", (v02, f27), true)
val eval_formula_test2703 = ("eval_formula_test2703", (v03, f27), true)
val eval_formula_test2704 = ("eval_formula_test2704", (v04, f27), true)
val eval_formula_test2801 = ("eval_formula_test2801", (v01, f28), true)
val eval_formula_test2802 = ("eval_formula_test2802", (v02, f28), true)
val eval_formula_test2803 = ("eval_formula_test2803", (v03, f28), true)
val eval_formula_test2804 = ("eval_formula_test2804", (v04, f28), true)
val eval_formula_test2901 = ("eval_formula_test2901", (v01, f29), true)
val eval_formula_test2902 = ("eval_formula_test2902", (v02, f29), false)
val eval_formula_test2903 = ("eval_formula_test2903", (v03, f29), false)
val eval_formula_test2904 = ("eval_formula_test2904", (v04, f29), true)
val eval_formula_test3001 = ("eval_formula_test3001", (v01, f30), false)
val eval_formula_test3002 = ("eval_formula_test3002", (v02, f30), true)
val eval_formula_test3003 = ("eval_formula_test3003", (v03, f30), false)
val eval_formula_test3004 = ("eval_formula_test3004", (v04, f30), true)
val eval_formula_test3101 = ("eval_formula_test3101", (v01, f31), false)
val eval_formula_test3102 = ("eval_formula_test3102", (v02, f31), false)
val eval_formula_test3103 = ("eval_formula_test3103", (v03, f31), true)
val eval_formula_test3104 = ("eval_formula_test3104", (v04, f31), true)
val eval_formula_test3201 = ("eval_formula_test3201", (v01, f32), true)
val eval_formula_test3202 = ("eval_formula_test3202", (v02, f32), true)
val eval_formula_test3203 = ("eval_formula_test3203", (v03, f32), true)
val eval_formula_test3204 = ("eval_formula_test3204", (v04, f32), true)
val eval_formula_tests = [eval_formula_test0101,eval_formula_test0102,eval_formula_test0103,eval_formula_test0104,eval_formula_test0201,eval_formula_test0202,eval_formula_test0203,eval_formula_test0204,eval_formula_test0301,eval_formula_test0302,eval_formula_test0303,eval_formula_test0304,eval_formula_test0401,eval_formula_test0402,eval_formula_test0403,eval_formula_test0404,eval_formula_test0501,eval_formula_test0502,eval_formula_test0503,eval_formula_test0504,eval_formula_test0601,eval_formula_test0602,eval_formula_test0603,eval_formula_test0604,eval_formula_test0701,eval_formula_test0702,eval_formula_test0703,eval_formula_test0704,eval_formula_test0801,eval_formula_test0802,eval_formula_test0803,eval_formula_test0804,eval_formula_test0901,eval_formula_test0902,eval_formula_test0903,eval_formula_test0904,eval_formula_test1001,eval_formula_test1002,eval_formula_test1003,eval_formula_test1004,eval_formula_test1101,eval_formula_test1102,eval_formula_test1103,eval_formula_test1104,eval_formula_test1201,eval_formula_test1202,eval_formula_test1203,eval_formula_test1204,eval_formula_test1301,eval_formula_test1302,eval_formula_test1303,eval_formula_test1304,eval_formula_test1401,eval_formula_test1402,eval_formula_test1403,eval_formula_test1404,eval_formula_test1501,eval_formula_test1502,eval_formula_test1503,eval_formula_test1504,eval_formula_test1601,eval_formula_test1602,eval_formula_test1603,eval_formula_test1604,eval_formula_test1701,eval_formula_test1702,eval_formula_test1703,eval_formula_test1704,eval_formula_test1801,eval_formula_test1802,eval_formula_test1803,eval_formula_test1804,eval_formula_test1901,eval_formula_test1902,eval_formula_test1903,eval_formula_test1904,eval_formula_test2001,eval_formula_test2002,eval_formula_test2003,eval_formula_test2004,eval_formula_test2101,eval_formula_test2102,eval_formula_test2103,eval_formula_test2104,eval_formula_test2201,eval_formula_test2202,eval_formula_test2203,eval_formula_test2204,eval_formula_test2301,eval_formula_test2302,eval_formula_test2303,eval_formula_test2304,eval_formula_test2401,eval_formula_test2402,eval_formula_test2403,eval_formula_test2404,eval_formula_test2501,eval_formula_test2502,eval_formula_test2503,eval_formula_test2504,eval_formula_test2601,eval_formula_test2602,eval_formula_test2603,eval_formula_test2604,eval_formula_test2701,eval_formula_test2702,eval_formula_test2703,eval_formula_test2704,eval_formula_test2801,eval_formula_test2802,eval_formula_test2803,eval_formula_test2804,eval_formula_test2901,eval_formula_test2902,eval_formula_test2903,eval_formula_test2904,eval_formula_test3001,eval_formula_test3002,eval_formula_test3003,eval_formula_test3004,eval_formula_test3101,eval_formula_test3102,eval_formula_test3103,eval_formula_test3104,eval_formula_test3201,eval_formula_test3202,eval_formula_test3203,eval_formula_test3204]
(* Uncomment the following to test your eval_formula function. *)
val _ = run_tests (fn (v, f) => eval_formula v f) bool_equal eval_formula_tests


(* tautology_formula tests *)
val tautology_formula_test01 = ("tautology_formula_test01", f01, false)
val tautology_formula_test02 = ("tautology_formula_test02", f02, false)
val tautology_formula_test03 = ("tautology_formula_test03", f03, false)
val tautology_formula_test04 = ("tautology_formula_test04", f04, true)
val tautology_formula_test05 = ("tautology_formula_test05", f05, false)
val tautology_formula_test06 = ("tautology_formula_test06", f06, false)
val tautology_formula_test07 = ("tautology_formula_test07", f07, false)
val tautology_formula_test08 = ("tautology_formula_test08", f08, true)
val tautology_formula_test09 = ("tautology_formula_test09", f09, false)
val tautology_formula_test10 = ("tautology_formula_test10", f10, false)
val tautology_formula_test11 = ("tautology_formula_test11", f11, false)
val tautology_formula_test12 = ("tautology_formula_test12", f12, true)
val tautology_formula_test13 = ("tautology_formula_test13", f13, false)
val tautology_formula_test14 = ("tautology_formula_test14", f14, false)
val tautology_formula_test15 = ("tautology_formula_test15", f15, false)
val tautology_formula_test16 = ("tautology_formula_test16", f16, true)
val tautology_formula_test17 = ("tautology_formula_test17", f17, false)
val tautology_formula_test18 = ("tautology_formula_test18", f18, false)
val tautology_formula_test19 = ("tautology_formula_test19", f19, false)
val tautology_formula_test20 = ("tautology_formula_test20", f20, true)
val tautology_formula_test21 = ("tautology_formula_test21", f21, false)
val tautology_formula_test22 = ("tautology_formula_test22", f22, false)
val tautology_formula_test23 = ("tautology_formula_test23", f23, false)
val tautology_formula_test24 = ("tautology_formula_test24", f24, true)
val tautology_formula_test25 = ("tautology_formula_test25", f25, false)
val tautology_formula_test26 = ("tautology_formula_test26", f26, false)
val tautology_formula_test27 = ("tautology_formula_test27", f27, false)
val tautology_formula_test28 = ("tautology_formula_test28", f28, true)
val tautology_formula_test29 = ("tautology_formula_test29", f29, false)
val tautology_formula_test30 = ("tautology_formula_test30", f30, false)
val tautology_formula_test31 = ("tautology_formula_test31", f31, false)
val tautology_formula_test32 = ("tautology_formula_test32", f32, true)
val tautology_formula_tests = [tautology_formula_test01,tautology_formula_test02,tautology_formula_test03,tautology_formula_test04,tautology_formula_test05,tautology_formula_test06,tautology_formula_test07,tautology_formula_test08,tautology_formula_test09,tautology_formula_test10,tautology_formula_test11,tautology_formula_test12,tautology_formula_test13,tautology_formula_test14,tautology_formula_test15,tautology_formula_test16,tautology_formula_test17,tautology_formula_test18,tautology_formula_test19,tautology_formula_test20,tautology_formula_test21,tautology_formula_test22,tautology_formula_test23,tautology_formula_test24,tautology_formula_test25,tautology_formula_test26,tautology_formula_test27,tautology_formula_test28,tautology_formula_test29,tautology_formula_test30,tautology_formula_test31,tautology_formula_test32]
(* Uncomment the following to test your tautology_formula function. *)
(* val _ = run_tests tautology_formula bool_equal tautology_formula_tests *)


(* tokenList_to_parseTree tests *)
val tokenList_to_parseTree_test01 = ("tokenList_to_parseTree_test01", ts01, SOME p01)
val tokenList_to_parseTree_test01x = ("tokenList_to_parseTree_test01x", ts01x, NONE)
val tokenList_to_parseTree_test02 = ("tokenList_to_parseTree_test02", ts02, SOME p02)
val tokenList_to_parseTree_test02x = ("tokenList_to_parseTree_test02x", ts02x, NONE)
val tokenList_to_parseTree_test03 = ("tokenList_to_parseTree_test03", ts03, SOME p03)
val tokenList_to_parseTree_test03x = ("tokenList_to_parseTree_test03x", ts03x, NONE)
val tokenList_to_parseTree_test04 = ("tokenList_to_parseTree_test04", ts04, SOME p04)
val tokenList_to_parseTree_test04x = ("tokenList_to_parseTree_test04x", ts04x, NONE)
val tokenList_to_parseTree_test05 = ("tokenList_to_parseTree_test05", ts05, SOME p05)
val tokenList_to_parseTree_test05x = ("tokenList_to_parseTree_test05x", ts05x, NONE)
val tokenList_to_parseTree_test06 = ("tokenList_to_parseTree_test06", ts06, SOME p06)
val tokenList_to_parseTree_test06x = ("tokenList_to_parseTree_test06x", ts06x, NONE)
val tokenList_to_parseTree_test07 = ("tokenList_to_parseTree_test07", ts07, SOME p07)
val tokenList_to_parseTree_test07x = ("tokenList_to_parseTree_test07x", ts07x, NONE)
val tokenList_to_parseTree_test08 = ("tokenList_to_parseTree_test08", ts08, SOME p08)
val tokenList_to_parseTree_test08x = ("tokenList_to_parseTree_test08x", ts08x, NONE)
val tokenList_to_parseTree_test09 = ("tokenList_to_parseTree_test09", ts09, SOME p09)
val tokenList_to_parseTree_test09x = ("tokenList_to_parseTree_test09x", ts09x, NONE)
val tokenList_to_parseTree_test10 = ("tokenList_to_parseTree_test10", ts10, SOME p10)
val tokenList_to_parseTree_test10x = ("tokenList_to_parseTree_test10x", ts10x, NONE)
val tokenList_to_parseTree_test11 = ("tokenList_to_parseTree_test11", ts11, SOME p11)
val tokenList_to_parseTree_test11x = ("tokenList_to_parseTree_test11x", ts11x, NONE)
val tokenList_to_parseTree_test12 = ("tokenList_to_parseTree_test12", ts12, SOME p12)
val tokenList_to_parseTree_test12x = ("tokenList_to_parseTree_test12x", ts12x, NONE)
val tokenList_to_parseTree_test13 = ("tokenList_to_parseTree_test13", ts13, SOME p13)
val tokenList_to_parseTree_test13x = ("tokenList_to_parseTree_test13x", ts13x, NONE)
val tokenList_to_parseTree_test14 = ("tokenList_to_parseTree_test14", ts14, SOME p14)
val tokenList_to_parseTree_test14x = ("tokenList_to_parseTree_test14x", ts14x, NONE)
val tokenList_to_parseTree_test15 = ("tokenList_to_parseTree_test15", ts15, SOME p15)
val tokenList_to_parseTree_test15x = ("tokenList_to_parseTree_test15x", ts15x, NONE)
val tokenList_to_parseTree_test16 = ("tokenList_to_parseTree_test16", ts16, SOME p16)
val tokenList_to_parseTree_test16x = ("tokenList_to_parseTree_test16x", ts16x, NONE)
val tokenList_to_parseTree_test17 = ("tokenList_to_parseTree_test17", ts17, SOME p17)
val tokenList_to_parseTree_test17x = ("tokenList_to_parseTree_test17x", ts17x, NONE)
val tokenList_to_parseTree_test18 = ("tokenList_to_parseTree_test18", ts18, SOME p18)
val tokenList_to_parseTree_test18x = ("tokenList_to_parseTree_test18x", ts18x, NONE)
val tokenList_to_parseTree_test19 = ("tokenList_to_parseTree_test19", ts19, SOME p19)
val tokenList_to_parseTree_test19x = ("tokenList_to_parseTree_test19x", ts19x, NONE)
val tokenList_to_parseTree_test20 = ("tokenList_to_parseTree_test20", ts20, SOME p20)
val tokenList_to_parseTree_test20x = ("tokenList_to_parseTree_test20x", ts20x, NONE)
val tokenList_to_parseTree_test21 = ("tokenList_to_parseTree_test21", ts21, SOME p21)
val tokenList_to_parseTree_test21x = ("tokenList_to_parseTree_test21x", ts21x, NONE)
val tokenList_to_parseTree_test22 = ("tokenList_to_parseTree_test22", ts22, SOME p22)
val tokenList_to_parseTree_test22x = ("tokenList_to_parseTree_test22x", ts22x, NONE)
val tokenList_to_parseTree_test23 = ("tokenList_to_parseTree_test23", ts23, SOME p23)
val tokenList_to_parseTree_test23x = ("tokenList_to_parseTree_test23x", ts23x, NONE)
val tokenList_to_parseTree_test24 = ("tokenList_to_parseTree_test24", ts24, SOME p24)
val tokenList_to_parseTree_test24x = ("tokenList_to_parseTree_test24x", ts24x, NONE)
val tokenList_to_parseTree_test25 = ("tokenList_to_parseTree_test25", ts25, SOME p25)
val tokenList_to_parseTree_test25x = ("tokenList_to_parseTree_test25x", ts25x, NONE)
val tokenList_to_parseTree_test26 = ("tokenList_to_parseTree_test26", ts26, SOME p26)
val tokenList_to_parseTree_test26x = ("tokenList_to_parseTree_test26x", ts26x, NONE)
val tokenList_to_parseTree_test27 = ("tokenList_to_parseTree_test27", ts27, SOME p27)
val tokenList_to_parseTree_test27x = ("tokenList_to_parseTree_test27x", ts27x, NONE)
val tokenList_to_parseTree_test28 = ("tokenList_to_parseTree_test28", ts28, SOME p28)
val tokenList_to_parseTree_test28x = ("tokenList_to_parseTree_test28x", ts28x, NONE)
val tokenList_to_parseTree_test29 = ("tokenList_to_parseTree_test29", ts29, SOME p29)
val tokenList_to_parseTree_test29x = ("tokenList_to_parseTree_test29x", ts29x, NONE)
val tokenList_to_parseTree_test30 = ("tokenList_to_parseTree_test30", ts30, SOME p30)
val tokenList_to_parseTree_test30x = ("tokenList_to_parseTree_test30x", ts30x, NONE)
val tokenList_to_parseTree_test31 = ("tokenList_to_parseTree_test31", ts31, SOME p31)
val tokenList_to_parseTree_test31x = ("tokenList_to_parseTree_test31x", ts31x, NONE)
val tokenList_to_parseTree_test32 = ("tokenList_to_parseTree_test32", ts32, SOME p32)
val tokenList_to_parseTree_test32x = ("tokenList_to_parseTree_test32x", ts32x, NONE)
val tokenList_to_parseTree_tests = [tokenList_to_parseTree_test01,tokenList_to_parseTree_test01x,tokenList_to_parseTree_test02,tokenList_to_parseTree_test02x,tokenList_to_parseTree_test03,tokenList_to_parseTree_test03x,tokenList_to_parseTree_test04,tokenList_to_parseTree_test04x,tokenList_to_parseTree_test05,tokenList_to_parseTree_test05x,tokenList_to_parseTree_test06,tokenList_to_parseTree_test06x,tokenList_to_parseTree_test07,tokenList_to_parseTree_test07x,tokenList_to_parseTree_test08,tokenList_to_parseTree_test08x,tokenList_to_parseTree_test09,tokenList_to_parseTree_test09x,tokenList_to_parseTree_test10,tokenList_to_parseTree_test10x,tokenList_to_parseTree_test11,tokenList_to_parseTree_test11x,tokenList_to_parseTree_test12,tokenList_to_parseTree_test12x,tokenList_to_parseTree_test13,tokenList_to_parseTree_test13x,tokenList_to_parseTree_test14,tokenList_to_parseTree_test14x,tokenList_to_parseTree_test15,tokenList_to_parseTree_test15x,tokenList_to_parseTree_test16,tokenList_to_parseTree_test16x,tokenList_to_parseTree_test17,tokenList_to_parseTree_test17x,tokenList_to_parseTree_test18,tokenList_to_parseTree_test18x,tokenList_to_parseTree_test19,tokenList_to_parseTree_test19x,tokenList_to_parseTree_test20,tokenList_to_parseTree_test20x,tokenList_to_parseTree_test21,tokenList_to_parseTree_test21x,tokenList_to_parseTree_test22,tokenList_to_parseTree_test22x,tokenList_to_parseTree_test23,tokenList_to_parseTree_test23x,tokenList_to_parseTree_test24,tokenList_to_parseTree_test24x,tokenList_to_parseTree_test25,tokenList_to_parseTree_test25x,tokenList_to_parseTree_test26,tokenList_to_parseTree_test26x,tokenList_to_parseTree_test27,tokenList_to_parseTree_test27x,tokenList_to_parseTree_test28,tokenList_to_parseTree_test28x,tokenList_to_parseTree_test29,tokenList_to_parseTree_test29x,tokenList_to_parseTree_test30,tokenList_to_parseTree_test30x,tokenList_to_parseTree_test31,tokenList_to_parseTree_test31x,tokenList_to_parseTree_test32,tokenList_to_parseTree_test32x]
(* Uncomment the following to test your tokenList_to_parseTree function. *)
val _ = run_tests tokenList_to_parseTree (option_equal parseTree_equal) tokenList_to_parseTree_tests


(* parseTree_to_formula tests *)
val parseTree_to_formula_test01 = ("parseTree_to_formula_test01", p01, f01)
val parseTree_to_formula_test02 = ("parseTree_to_formula_test02", p02, f02)
val parseTree_to_formula_test03 = ("parseTree_to_formula_test03", p03, f03)
val parseTree_to_formula_test04 = ("parseTree_to_formula_test04", p04, f04)
val parseTree_to_formula_test05 = ("parseTree_to_formula_test05", p05, f05)
val parseTree_to_formula_test06 = ("parseTree_to_formula_test06", p06, f06)
val parseTree_to_formula_test07 = ("parseTree_to_formula_test07", p07, f07)
val parseTree_to_formula_test08 = ("parseTree_to_formula_test08", p08, f08)
val parseTree_to_formula_test09 = ("parseTree_to_formula_test09", p09, f09)
val parseTree_to_formula_test10 = ("parseTree_to_formula_test10", p10, f10)
val parseTree_to_formula_test11 = ("parseTree_to_formula_test11", p11, f11)
val parseTree_to_formula_test12 = ("parseTree_to_formula_test12", p12, f12)
val parseTree_to_formula_test13 = ("parseTree_to_formula_test13", p13, f13)
val parseTree_to_formula_test14 = ("parseTree_to_formula_test14", p14, f14)
val parseTree_to_formula_test15 = ("parseTree_to_formula_test15", p15, f15)
val parseTree_to_formula_test16 = ("parseTree_to_formula_test16", p16, f16)
val parseTree_to_formula_test17 = ("parseTree_to_formula_test17", p17, f17)
val parseTree_to_formula_test18 = ("parseTree_to_formula_test18", p18, f18)
val parseTree_to_formula_test19 = ("parseTree_to_formula_test19", p19, f19)
val parseTree_to_formula_test20 = ("parseTree_to_formula_test20", p20, f20)
val parseTree_to_formula_test21 = ("parseTree_to_formula_test21", p21, f21)
val parseTree_to_formula_test22 = ("parseTree_to_formula_test22", p22, f22)
val parseTree_to_formula_test23 = ("parseTree_to_formula_test23", p23, f23)
val parseTree_to_formula_test24 = ("parseTree_to_formula_test24", p24, f24)
val parseTree_to_formula_test25 = ("parseTree_to_formula_test25", p25, f25)
val parseTree_to_formula_test26 = ("parseTree_to_formula_test26", p26, f26)
val parseTree_to_formula_test27 = ("parseTree_to_formula_test27", p27, f27)
val parseTree_to_formula_test28 = ("parseTree_to_formula_test28", p28, f28)
val parseTree_to_formula_test29 = ("parseTree_to_formula_test29", p29, f29)
val parseTree_to_formula_test30 = ("parseTree_to_formula_test30", p30, f30)
val parseTree_to_formula_test31 = ("parseTree_to_formula_test31", p31, f31)
val parseTree_to_formula_test32 = ("parseTree_to_formula_test32", p32, f32)
val parseTree_to_formula_tests = [parseTree_to_formula_test01,parseTree_to_formula_test02,parseTree_to_formula_test03,parseTree_to_formula_test04,parseTree_to_formula_test05,parseTree_to_formula_test06,parseTree_to_formula_test07,parseTree_to_formula_test08,parseTree_to_formula_test09,parseTree_to_formula_test10,parseTree_to_formula_test11,parseTree_to_formula_test12,parseTree_to_formula_test13,parseTree_to_formula_test14,parseTree_to_formula_test15,parseTree_to_formula_test16,parseTree_to_formula_test17,parseTree_to_formula_test18,parseTree_to_formula_test19,parseTree_to_formula_test20,parseTree_to_formula_test21,parseTree_to_formula_test22,parseTree_to_formula_test23,parseTree_to_formula_test24,parseTree_to_formula_test25,parseTree_to_formula_test26,parseTree_to_formula_test27,parseTree_to_formula_test28,parseTree_to_formula_test29,parseTree_to_formula_test30,parseTree_to_formula_test31,parseTree_to_formula_test32]
(* Uncomment the following to test your parseTree_to_formula function. *)
val _ = run_tests parseTree_to_formula formula_equal parseTree_to_formula_tests

in
end
