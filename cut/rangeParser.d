import std.stdio;
import std.conv,
        std.array,
        std.algorithm
        ;

struct Range {
    ulong low;
    ulong high; //A value of int.max means range is till EOL
    
    public bool inRange(ulong pos)
    {
        return (pos >= low-1 && pos <= high-1);
    }
}

enum Lexeme {
    NUMBER,
    HYPHEN,
    COMMA,
    UNKNOWN,
    END,
}

enum State {
    START,
    NUMBER,
    HYPHEN_W_NUMBER,
    HYPHEN_WO_NUMBER,
    PROCESS_RANGE,
    ERROR,
    END,
}

/**
 * State Machine based LL(1) parser for ranges.

   Allows strings of the format NUMBER[-[NUMBER]],...
*/
Range[] parseRange(string str)
{
    State   lastState = State.START;
    char[]  charStack; // Used to store chars of ints successively. 
    int[]   intStack;  // Used to stores processed integers that are not yet part of a range
    Range[] ranges;    // Stores final processed ranges
    
    /*
        Loop through each character in the string. Identify the lexeme. Use the lexeme and 
        the current STATE to get to the next STATE. In case of invalid state throw Exception
    */
    foreach(c; str) {
        
        //Get the Lexeme
        Lexeme l = getLexeme(c);
        if(l == Lexeme.UNKNOWN)
            throw new Exception("Unkown lexeme " ~ c);
            
        debug {
            write("LAST STATE=", lastState, ", LEXEME=" , l, ", ");
        }
        
        //Using the currentState and lexeme get the next state
        State state = getState(lastState, l); 
        if(state == State.ERROR)
            throw new Exception("Parser error");
            
        debug {
            writeln("NEW STATE=", state);
        }
        
        if(state == State.NUMBER)
        {
            //If the lexeme is a number, push it on our charStack.
            charStack ~= c;
        }
        else if(state == State.HYPHEN_W_NUMBER)
        {
            /*
                If the lexeme is a hyphen after a number, parse the charStack
                into an int and push it onto intStack. instack is used in PROCESS_RANGE state.
                Clear the charStack
            */
            convertToIntAndPush(charStack, intStack);
        }
        else if(state == State.HYPHEN_WO_NUMBER)
        {
            // If a range starts with a hyphen, it means the range starts from 1.
            intStack ~= 1;
        }
        else if(state == State.PROCESS_RANGE)
        {
            // Parse chars to an int. There should be 1-2 ints in the stack
            convertToIntAndPush(charStack, intStack);
            assert(intStack.length > 0 && intStack.length < 3);
            
            Range r;
            if(intStack.length == 1)
            {
                /*
                    If there is only one int on the stack it means the range was either :
                    'INT' or 'INT-EOL'
                
                    If the last state was HYPHEN_W_NUMBER, it means this range is INT-EOL.
                */
                r = Range(intStack[0], (lastState == State.HYPHEN_W_NUMBER) ? int.max : intStack[0]);
            }
            else if(intStack.length == 2) 
            {
                // Make sure range is in the right order
                if(intStack[0] > intStack[1]) {
                    throw new Exception("Range is wrong. " ~ to!string(intStack[0]) ~ " > " ~ to!string(intStack[1]));
                }
                
                // Make a range of the form 'INT-INT'
                r = Range(intStack[0], intStack[1]);
            }
             
             // Push the parsed Range onto ranges
            ranges ~= r;
            
            //Clear the int stack
            intStack = [];
        }
        
        lastState = state;
    }
    
    return ranges;
}

/**
 * State Machine for ranges.

   Allows NUMBER[-[NUMBER]],...

   Given a currState and a Lexeme, identifies what the next state should be.
*/
State getState(State currState, Lexeme l)
{
         if(currState == State.START && l == Lexeme.NUMBER)
        return State.NUMBER;
    else if(currState == State.START && l == Lexeme.HYPHEN)
        return State.HYPHEN_WO_NUMBER;
        
        else if(currState == State.NUMBER && l == Lexeme.NUMBER)
        return State.NUMBER;
    else if(currState == State.NUMBER && l == Lexeme.HYPHEN)
        return State.HYPHEN_W_NUMBER;
    else if(currState == State.NUMBER && l == Lexeme.COMMA)
        return State.PROCESS_RANGE;
    else if(currState == State.NUMBER && l == Lexeme.END)
        return State.PROCESS_RANGE;
        
    else if(currState == State.HYPHEN_W_NUMBER && l == Lexeme.NUMBER)
        return State.NUMBER;
    else if(currState == State.HYPHEN_W_NUMBER && l == Lexeme.COMMA)
        return State.PROCESS_RANGE;
    else if(currState == State.HYPHEN_W_NUMBER && l == Lexeme.END)
        return State.PROCESS_RANGE;
    
    else if(currState == State.HYPHEN_WO_NUMBER && l == Lexeme.NUMBER)
        return State.NUMBER;
        
    else if(currState == State.PROCESS_RANGE && l == Lexeme.NUMBER)
        return State.NUMBER;
        
    return State.ERROR;
}

private :
 
    /*
     Identifies the char as a Lexeme, or returns Lexeme.UNKNOWN
    */
    Lexeme getLexeme(char c)
    {
        char[] numbers = ['0','1','2','3','4','5','6','7','8','9'];
        
        if(!find(numbers, c).empty)
            return Lexeme.NUMBER;
        else if(c == '-')
            return Lexeme.HYPHEN;
        else if(c == ',')
            return Lexeme.COMMA;
        else if(c == '\0')
            return Lexeme.END;
            
        return Lexeme.UNKNOWN;
    }
    
    void convertToIntAndPush(ref char[] charStack, ref int[] intStack)
    {
        if(!charStack.length)
            return;
            
        int i = to!int(charStack);
        if(i < 1)
            throw new Exception("Number cannot be < 1");
            
        intStack ~= i;
        charStack = [];
    }

unittest {
    
    auto ranges = parseRange("-2,4-5,8-");
    assert(ranges.length == 3);
    assert(ranges[0] == Range(1,2));
    assert(ranges[1] == Range(4,5));
    assert(ranges[2] == Range(8,int.max));
    
    try {
        parseRange("-2,a");
        assert(false);
    } catch(Exception e) {
        assert(e.msg == "Unkown lexeme a");
    }
}