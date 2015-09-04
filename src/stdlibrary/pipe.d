import std.algorithm;
import std.array;
import std.conv;
import std.functional;
import std.stdio;

alias sumString = pipe!(split, map!(to!(int)), sum);
alias sumStringInv = compose!(sum, map!(to!(int)), split);

void main(string[] args)
{
    auto result = sumString("1 2 3 4 5 6 7 8 9");
    writeln(result);
    
    result = sumStringInv("1 2 3 4 5 6 7 8 9");
    writeln(result);
}
