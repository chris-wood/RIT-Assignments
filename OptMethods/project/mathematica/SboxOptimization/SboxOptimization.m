(* Mathematica Package *)

(* Created by the Wolfram Workbench Apr 28, 2012 *)

BeginPackage["SboxOptimization`"]
(* Exported symbols added here with SymbolName::usage *) 

Begin["`Private`"]
(* Implementation of the package *)

branchNumber[sbox_, nElements_] :=
	minVal = nElements
	Print[minVal]
	
	(*For[a = 0,a < nElements, a++,For[b = 1, b < nElements; b++, Print[a + " " + b]]]*)
    
    (*
    % Fetch the size of the S-box
    [~, sc] = size(S);
    
    % Perform the branch number calculation over all combinations of 
    % numbers in this field.
	for a = 1:sc
		for b = 1:sc
            if (a ~= b)
                x = wt(xor(a - 1,b - 1), bits);
                y = wt(xor(S(a), S(b)), bits);
                if (x + y < minVal)
                    minVal = x + y;
                    pair(1,1) = a - 1;
                    pair(1,2) = b - 1;
                end
            end
		end 
	end	
	n = minVal; 
	*)

End[]

EndPackage[]

