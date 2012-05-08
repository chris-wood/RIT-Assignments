using System;

namespace Test
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.WriteLine ("Hello World!");
			BCHDecoder3121 decoder = new BCHDecoder3121();
			String hex = "0xB66E4A73";
			int codeword = System.Convert.ToInt32(hex, 16);
			Console.WriteLine(decoder.correct(codeword));
		}
	}
}
