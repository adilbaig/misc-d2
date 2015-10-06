import std.mmfile;
import std.stdio;
import std.conv;

void main(string[] args)
{
    // Read an mmfile;
    auto file = new MmFile(args[1], MmFile.Mode.readWrite, 0, null, 4096);
    char[] text = cast(char[])file[];
    
    writeln(" ========= ORIGINAL FILE ========= ");
    writeln(text);
    writeln(" ========= END ORIGINAL FILE ========= ");
    
    /*
     Now update some data.
     The way to do this is to take a slice from the mmap array, then write to that slice.
     This will be propagated to the MmFile
    */
    auto str = "Appending my name to the head : Adil\n";
    text[0 .. str.length] = str;
    
    writeln(cast(char[])file[]);
}