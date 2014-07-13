import std.stdio;
import std.string : format;
import std.range : iota;

void main()
{
	writeln("Hello World");
	
	foreach(i; iota(50))
		writeln(format("*%d\r\n%s", 32, "What's up"));
	
	pragma(msg, "writeln(\"Hello World\");");
	mixin("writeln(\"Hello World\");");
}