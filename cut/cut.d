import std.stdio,
        std.getopt,
        std.file,
        std.conv,
        std.array,
        std.algorithm
        ;
        
import rangeParser;

void usage(string command)
{
    writeln(command, "
Usage: cut OPTION... FILE...
Print selected parts of lines from each FILE to standard output.

Mandatory arguments to long options are mandatory for short options too.
  -b, --bytes=LIST        select only these bytes
  -d, --delimiter=DELIM   use DELIM instead of TAB for field delimiter
  -f, --fields=LIST       select only these fields;  also print any line
                            that contains no delimiter character, unless
                            the -s option is specified
      --complement        complement the set of selected bytes, characters
                            or fields

Use one, and only one of -b or -f.  Each LIST is made up of one
range, or many ranges separated by commas.  Selected input is written
in the same order that it is read, and is written exactly once.
Each range is one of:

  N     N'th byte, character or field, counted from 1
  N-    from N'th byte, character or field, to end of line
  N-M   from N'th to M'th (included) byte, character or field
  -M    from first to M'th (included) byte, character or field

");
}

int main(string[] args)
{
    if (args.length < 2)
    {
        usage(args[0]);
        return 1;
    }
    
    string bytes = "";
    string fields = "";
    char delimiter = '\t';
    bool complement = false;
    getopt(args, "bytes|b", &bytes, "fields|f", &fields, "delimiter|d", &delimiter, "complement", &complement);
    
    if((bytes.length && fields.length) || (!bytes.length && !fields.length))
    {
        usage(args[0]);
        return 1;
    }
    
    bool parseFields = cast(bool)(fields.length);
    
    string str = ((!parseFields) ? bytes : fields) ~= '\0';
    Range[] ranges = parseRange(str);
    
    debug {
        writeln(ranges);
    }
    
    auto file = File(args[1]); // Open for reading
    
    /*
     For bytes, read each byte and compare to printing range
     if in range, print else skip
     For fields accumalate chars until \t. That is the first field,
     if in list, print, else discard.
    */
    foreach (line; file.byLine())
    {
        if (line.empty)
            continue;
        
        if(parseFields)
        {
            auto arr = cast(string[])split(line, to!string(delimiter));
            printRange!(string)(arr, ranges, delimiter, complement);
        }
        else
            printRange!(char)(line, ranges, '\0', complement);
        
        writeln("");
    }
    
    return 0;
}

private void printRange(S)(S[] array, Range[] ranges, char delimiter, bool complement)
{
    foreach(i, token; array) {
        foreach(r; ranges) {
            bool b = (complement) ? !r.inRange(i) : r.inRange(i);
            if(b) {
                write(token, delimiter);
                break;
            }
        }
    }
}