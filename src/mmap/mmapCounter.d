import std.mmfile;
import std.stdio;
import std.conv;
import core.sys.posix.unistd;

union bum {
    uint ctr;
    byte[4] bytes;
}

/**
 INSTRUCTIONS : Create an empty file, then start this process and watch the counter
 Now start another process and watch the counter increment at twice the speed. Mmap
 is sharing the file between the processes
 */
void main(string[] args)
{
     // Read an mmfile;
    auto file = new MmFile(args[1], MmFile.Mode.readWrite, 20, null, 4096);
    byte[] bytes = cast(byte[])file[];
    
    writeln(bytes);
    
    bum b;
    
    while(true) {
        b.bytes = bytes[0 .. 4];
        b.ctr++;
        bytes[0 .. 4] = b.bytes;
        
        writeln(bytes);
         
        sleep(1);
    }
}