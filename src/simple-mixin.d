import std.stdio;

void main()
{
	writeln("Hello World");
	
	pragma(msg, "writeln(\"Hello World\");");
	mixin("writeln(\"Hello World\");");
}