package tests;

import org.antlr.runtime.ANTLRStringStream;
import org.antlr.runtime.CharStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.RecognitionException;
import org.antlr.runtime.TokenStream;

import gclSpecification.gclLex;
import gclSpecification.gclParser;

public class Test1 {
	
	public static void main(String[] args) throws RecognitionException {
		CharStream characterStream=new ANTLRStringStream("once upon a time");
		gclLex lexer=new gclLex(characterStream);
		
		TokenStream tokenStream=new CommonTokenStream(lexer);
		gclParser parser=new gclParser(tokenStream);
		parser.program();
		System.out.println("Done!");
	}

}
