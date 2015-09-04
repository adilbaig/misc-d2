import std.bitmanip;
 
struct Foo
{
    mixin(bitfields!(
        uint, "x", 5,
        uint, "y", 5,
        uint, "z", 5,
        bool, "flag", 1,
    ));
}
 
void main(string[] args)
{
    Foo foo = Foo(0b_1_00011_00010_00001); // Initialisation values in binary.
 
    assert(foo.sizeof == 2); //2 bytes
 
    assert(foo.x == 1);
    assert(foo.y == 2);
    assert(foo.z == 3);
    assert(foo.flag == true);
}