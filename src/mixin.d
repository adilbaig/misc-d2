mixin template property(T)
{
    private T member;

    public T get()
    {
        return member;
    }

    public void set(T value)
    {
        member = value;
    }
}

class C
{
    mixin property!(int);
}

void main()
{
    auto x = new C();
    x.set(123);

    assert(x.get() == 123);
}