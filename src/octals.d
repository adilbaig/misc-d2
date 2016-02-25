
/**
 Pg 232, D Cookbook
*/

int readOctalString(string n)
{
    int sum = 0;
    foreach(c;n) {
        if (c < '0' || c > '7')
            throw new Exception("Bad octal number " ~ n);
        
        sum *= 8;
        sum += c - '0';
    }
    
    return sum;
}

unittest {
    assert(readOctalString("10") == 8);
    assert(readOctalString("15") == 13);
    assert(readOctalString("4") == 4);
    
    import std.exception;
    assertThrown!Exception(readOctalString("90"));
}

template octal(string s) {
    enum octal = readOctalString(s);
}

template octal(int i) {
    import std.conv;
    enum octal = octal!(to!string(i));
}

void main()
{
    import std.stdio;
    writeln(octal!10);
    writeln(octal!"15");
    writeln(octal!4);
}