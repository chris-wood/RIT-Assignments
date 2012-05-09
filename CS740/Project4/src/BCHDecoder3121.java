/*
 * BCHDecoder3121.java
 * 
 * Version: 3/20/12
 */

/**
 * This class is responsible for handling the BCH(31,21) decoding of
 * 32-bit codewords as they are retrieved from the server. 
 * 
 * @author Jeremey Brown
 * @Contributor Christopher Wood (caw4567@rit.edu)
 */
public class BCHDecoder3121 
{
	/**
	 * Some useful constants for this form of BCH encoding/decoding
	 */
	public static final int DATA_BYTES = 3;
	public static final int CKSUM_BYTES = 1;
	
	/**
	 * Constants for the order of the Galois field.
	 */
	private int FIELD_POWER = 5;
	private int FIELD_ORDER = 31;
	
	/**
	 * The members for the BCH decoder that store the order and values 
	 * of the Galois field used for decoding, as well as the primitive
	 * polynomial used for reduction.
	 */
	private int[] p = new int[6];
	private int[] GF = new int[32];
	private int[] GF_rev = new int[32];
	
	/**
	 * Constructor that initializes the primitive polynomial and
	 * then the Galois field.
	 */
	public BCHDecoder3121()
	{	
        // Primitive polynomial of degree 5
        // x^5 + x^2 + 1
        // polynomial is indivisible, ie: 100101 = 21, which is prime, therefore indivisible
        p[0] = p[2] = p[5] = 1;
        p[1] = p[3] = p[4] = 0;
        InitializeDecoder();
	}
	
	/**
	 * Initialize the decoder by generating the Galois field GF(2**m).
	 */
	private void InitializeDecoder()
    {
        GenerateGf();
    }

	/**
     * Generate GF(2**m) from the irreducible polynomial p(X) in p[0]..p[m]
     * lookup tables:  
     * 
     * index->polynomial form   GF[] contains j=alpha**i;
     * polynomial form -> index form  GF_rev[j=alpha**i] = i
     *  
     * alpha = 2 is the primitive element of GF(2**m) 
     */
    private void GenerateGf()
    {
    	 int i;
    	 int mask;
    	 
    	 // Initialization
         mask = 1;
         GF[FIELD_POWER] = 0;

         for (i = 0; i < FIELD_POWER; i++)
         {
             GF[i] = mask;

             GF_rev[GF[i]] = i;

             if (p[i] != 0)
                 GF[FIELD_POWER] ^= mask;

             mask <<= 1;
         }

         GF_rev[GF[FIELD_POWER]] = FIELD_POWER;

         mask >>= 1;

         for (i = FIELD_POWER + 1; i < FIELD_ORDER; i++)
         {
             if (GF[i - 1] >= mask)
                 GF[i] = GF[FIELD_POWER] ^ ((GF[i - 1] ^ mask) << 1);
             else
                 GF[i] = GF[i - 1] << 1;

             GF_rev[GF[i]] = i;
         }

         GF_rev[0] = -1;
    }

    /**
     * Calculate the syndrome for a codeword that contains information
     * regarding the location of errors in such word.
     * 
     * @param codeword - the codeword to check against
     * @return - the 2t element syndrome vector.
     */
    private int[] calcSyndrom(int codeword)
    {
    	int[] result = new int[] { 0, 0, 0, 0 };
        for (int i = 0; i < 4; i++)
        {
            for (int j = 0; j < FIELD_ORDER; j++)
            {
                if (((codeword >> (j + 1)) & 1) != 0)
                {
                    result[i] ^= GF[(i + 1) * j % FIELD_ORDER];
                }
            }
            result[i] = GF_rev[result[i]];
        }
        return result;
    }

    /**
     * Correct the specified codeword if it contains up to two codewords. 
     * 
     * @param codeword - the codeword to correct.
     * @return - the correct codeword (or the same if no errors were present).
     */
    public int correct(int codeword)
    {
    	int[] S = new int[] { 0, 0, 0, 0 };
        int s3 = 0;
        int[] C = new int[] { 0, 0, 0 };
        int[] loc = new int[] { 0, 0, 0 };
        int tmp = 0;
        boolean error = false;
        int errors = 0;

        S = calcSyndrom(codeword);
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
            return codeword; 
        }

        if (S[0] != -1)
        {
            s3 = (S[0] * 3) % FIELD_ORDER;

            // Is there only one error?
            if (S[2] == s3)
            {
                codeword ^= 1 << (S[0] + 1);
                errors = 1;
            }
            else
            {
                // There are (hopefully) only two errors
                // Solve for the coefficients of C(X) for the error locator
                // polynomial
                tmp = GF[s3];
                if (S[2] != -1)
                {
                    tmp ^= GF[S[2]];
                }


                C[0] = 0;
                C[1] = (S[1] - GF_rev[tmp] + FIELD_ORDER) % FIELD_ORDER;
                C[2] = (S[0] - GF_rev[tmp] + FIELD_ORDER) % FIELD_ORDER;

                //# Get the roots of C(x) using Chien-Search
                errors = 0;
                for (int i = 0; i < FIELD_ORDER; i++)
                {
                    tmp = 1;
                    for (int j = 1; j < 3; j++)
                    {
                        if (C[j] != -1)
                        {
                            C[j] = (C[j] + j) % FIELD_ORDER;
                            tmp ^= GF[C[j]];
                        }

                    }
                    if (tmp == 0)
                    {
                        loc[errors] = (i + 1) % FIELD_ORDER;
                        errors += 1;
                    }
                }

                if (errors == 2)
                {
                    codeword ^= (1 << (loc[0] + 1));
                    codeword ^= (1 << (loc[1] + 1));
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
                System.out.println("NOT FIXED");
                break;
            }
        }

        return codeword; 
    }
} // BCHDecoder3121
