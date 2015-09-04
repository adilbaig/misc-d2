
import std.algorithm;
import std.stdio;
import std.conv;

void main(string[] args)
{
    foreach (input; 1..50)
    {
        input.predSwitch!("a % b == 0")(
            15, "fizzbuzz",
            5, "buzz",
            3, "fizz",
            input.text
        ).writeln();
    }
}