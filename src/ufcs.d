import std.algorithm;
import std.range;
import std.stdio;

void main()
{
    auto x = iota(50)
        .map!(a => a + 1)
        .filter!(a => a % 5 == 0)
        .array
        .reverse;

    writeln(iota(50));
    writeln(iota(50)
        .map!(a => a + 1));
    writeln(iota(50)
        .map!(a => a + 1)
        .filter!(a => a % 5 == 0)); 
    writeln(iota(50)
        .map!(a => a + 1)
        .filter!(a => a % 5 == 0)
        .array);
    writeln(iota(50)
        .map!(a => a + 1)
        .filter!(a => a % 5 == 0)
        .array
        .reverse);
    assert(x == [50, 45, 40, 35, 30, 25, 20, 15, 10, 5]);
}