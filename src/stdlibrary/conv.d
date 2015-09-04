import std.conv;

void main(string[] args)
{
    int foo;
    long bar = castFrom!(int).to!(long)(foo);
}