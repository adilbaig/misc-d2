

class Foo
{
    private int _bar;
 
    int bar()
    {
        return _bar;
    }
 
    void bar(int value)
    {
        this._bar = value;
    }
}

void foo(int a)
{
    assert(a == 123);
}
 
void main()
{
    foo = 123;  // called as foo(123)
//    foo = 124; //Assertion failure
    
    auto F = new Foo();
    F.bar = 12;
    assert(F.bar == 12);
}