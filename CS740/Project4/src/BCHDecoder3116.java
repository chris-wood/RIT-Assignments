public class BCHDecoder3116 
{
	static int m, n, t;
	static int[] p = new int[8]; 
	static int[] GF = new int[32];
	static int[] GF_rev = new int[32];
	
	public BCHDecoder3116()
	{
		m = 5;
		n = 31;
		t = 3;
        
		// Primitive polynomial of degree 7
        // x^7 + x^3 + 1
        p[7] = p[3] = p[0] = 1;
        p[6] = p[5] = p[4] = p[2] = p[1] = 0;
		
		// Primitive polynomial of degree 5
        // x^5 + x^2 + 1
        // polynomial is indivisible, ie: 10101 = 21, which is prime, therefore invisisible
        //p[0] = p[2] = p[5] = 1;
        //p[1] = p[3] = p[4] = 0;
        
        // Initialize the decoder using this generator polynomial
        InitializeDecoder();
	}
	
	static void InitializeDecoder()
    {
		m = 5;
		n = 31;
		t = 3;
        
		// Primitive polynomial of degree 7
        // x^7 + x^3 + 1
        p[7] = p[3] = p[0] = 1;
        p[6] = p[5] = p[4] = p[2] = p[1] = 0;
		
        GenerateGf(); // Generate the Galois Field GF(2**m) 
    }

    static void GenerateGf()
    {
    	/*
         * generate GF(2**m) from the irreducible polynomial p(X) in p[0]..p[m]
         * lookup tables:  
         * 
         * index->polynomial form   GF[] contains j=alpha**i;
         * polynomial form -> index form  GF_rev[j=alpha**i] = i
         *  
         * alpha = 2 is the primitive element of GF(2**m) 
         */

    	int i, mask;
        mask = 1;
        GF[m] = 0;

        for (i = 0; i < m; i++)
        {
            GF[i] = mask;

            GF_rev[GF[i]] = i;

            if (p[i] != 0)
                GF[m] ^= mask;

            mask <<= 1;
        }

        GF_rev[GF[m]] = m;

        mask >>= 1;

        for (i = m + 1; i < n; i++)
        {
            if (GF[i - 1] >= mask)
                GF[i] = GF[m] ^ ((GF[i - 1] ^ mask) << 1);
            else
                GF[i] = GF[i - 1] << 1;

            GF_rev[GF[i]] = i;
        }

        GF_rev[0] = -1;
        
         
        System.out.println("i - alpha_to - index_to");
        for (i = 0; i < Math.pow(2, m); i++)
        {
        	System.out.println(i + " - " + GF[i] + " - " + GF_rev[i]);
        }
    }

    private static int[] calcSyndrom(int codeword)
    {
        int[] result = new int[] { 0, 0, 0, 0, 0, 0 };
        for (int i = 0; i < 6; i++)
        {
            for (int j = 0; j < n; j++)
            {
                if (((codeword >> (j + 1)) & 1) != 0)
                {
                    result[i] ^= GF[(i + 1) * j % n];
                }
            }
            result[i] = GF_rev[result[i]];
        }
        return result;
    }

    public static String correct(int codeword)
    {
    	int[] S = new int[] { 0, 0, 0, 0, 0, 0 };
        int s3 = 0;
        int[] C = new int[] { 0, 0, 0, 0 };
        int[] loc = new int[] { 0, 0, 0 };
        int tmp = 0;
        boolean error = false;
        int errors = 0;

        int initialCW = codeword;
        int nbCorr = 0;
        boolean good = true;

        S = calcSyndrom(codeword);
        for (int i = 0; i < S.length; i++)
        {
        	System.out.println(S[i]);
            if (S[i] != -1)
            {
                error = true;
                //break;
            }
        }

        if (!error)
        {
            return "NONE - initialCW: " + initialCW + "   cw: " + codeword + "   nbCorr: " + nbCorr + "    good: " + good;
        }

        if (S[0] != -1)
        {
            s3 = (S[0] * 3) % n;

            // Is there only one error?
            if (S[2] == s3)
            {
                codeword ^= 1 << (S[0] + 1);
                errors = 1;
            }
            else
            {
            	System.out.println("n >=2 errors");
                // There are (hopefully) only two errors
                // Solve for the coefficients of C(X) for the error locator
                // polynomial
                tmp = GF[s3];
                if (S[2] != -1)
                {
                    tmp ^= GF[S[2]];
                }

                C[0] = 0; // was 0
                C[1] = (S[1] - GF_rev[tmp] + n) % n;
                C[2] = (S[0] - GF_rev[tmp] + n) % n;
                C[3] = (S[2] - GF_rev[tmp] + n) % n;
                //C[3] = (S[0] - GF_rev[tmp] + n) % n;
                //C[4] = (S[0] - GF_rev[tmp] + n) % n;

                // Get the roots of C(x) using Chien-Search
                errors = 0;
                for (int i = 0; i < n; i++)
                {
                    tmp = 1;
                    for (int j = 1; j < 3; j++)
                    {
                        if (C[j] != -1)
                        {
                            C[j] = (C[j] + j) % n;
                            tmp ^= GF[C[j]];
                        }
                    }
                    if (tmp == 0)
                    {
                        loc[errors] = (i + 1) % n;
                        errors += 1;
                    }
                }

                System.out.println("#errors = " + errors);
                if (errors == 2)
                {
                    codeword ^= (1 << (loc[0] + 1));
                    codeword ^= (1 << (loc[1] + 1));
                }
                else if (errors == 3)
                {
                	codeword ^= (1 << (loc[0] + 1));
                    codeword ^= (1 << (loc[1] + 1));
                    codeword ^= (1 << (loc[2] + 1));
                }
            }
        }
        S = calcSyndrom(codeword);
        error = false;

        for (int i = 0; i < S.length; i++)
        {
            if (S[i] != -1)
            {
                error = true;
                break;
            }
        }

        if (!error)
        {
            nbCorr = errors;
        }
        else
        {
            good = false;
        }

        return "initialCW: " + initialCW + "   cw: " + codeword + "   nbCorr: " + nbCorr + "    good: " + good;
    }
}