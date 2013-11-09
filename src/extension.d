import std.algorithm;
import std.range;
 
int[] increment(int[] x)
{
    return x.map!(a => a + 1).array;
}
 
void main()
{
    int[] x = [1, 2, 3, 4, 5];
 
    assert(x.increment() == [2, 3, 4, 5, 6]);
}