
import std.typecons;

class Foo
{
    public int x;
}

// Here the unique resource is passed by reference. This means this function
// borrows it for the duration of the function.
void borrow(ref Unique!(Foo) foo)
{
}

// Here the unique resource is passed by value and therefore copied.
// Because it's copied, this function requires full ownership of the resource.
void own(Unique!(Foo) foo)
{
}

void main(string[] args)
{
    Unique!(Foo) foo = new Foo();

    assert(!foo.isEmpty);
    borrow(foo);
    assert(!foo.isEmpty);

    // own(foo); //Error: struct std.typecons.Unique!(Foo).Unique is not copyable because it is annotated with @disable
    own(foo.release());
    assert(foo.isEmpty);
}