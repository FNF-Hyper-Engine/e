package funkin.macros;

import hscript.Macro;
import haxe.macro.Context;

class GithubThing
{
     static function main() {
        e();
    }
	public static function e()
	{
		trace('grabbin github crap ');


		// Get the current line number.


		var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
	
		// read the output of the process
		var commitHash:String = process.stdout.readLine();
		var commitHashSplice:String = commitHash.substr(0, 7);
        
        //Globals.gitCommit = commitHashSplice;
		process.close();

		trace('Git Commit ID: ${commitHashSplice}');


		// Generates a string expression
		return commitHashSplice;
	

		//return macro {};
	}
}
