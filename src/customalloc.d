import std.c.stdlib;
import core.exception;
import core.memory : GC;
import std.stdio;

class Foo
{
    this()
    {
        writeln("Constructor called");
    }
    
    new(size_t sz)
    {
        writeln("new() called");
        void* p;

        p = std.c.stdlib.malloc(sz);

        if (!p)
            throw new OutOfMemoryError();

        GC.addRange(p, sz);
        return p;
    }

    delete(void* p)
    {
        writeln("delete() called");
        if (p)
        {
            GC.removeRange(p);
            std.c.stdlib.free(p);
        }
    }
}

void main()
{
    //Using custom allocator
    auto f = new Foo();
    writeln("sizeof : ", f.sizeof);
}