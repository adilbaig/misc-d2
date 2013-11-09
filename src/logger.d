import std.syslog;
import std.stdio;

void main()
{
    writeln("Writing to log");
    
    setlogmask (LOG_UPTO (LOG_ALERT));
    openlog ("exampleprog", LOG_CONS | LOG_PID | LOG_NDELAY, LOG_LOCAL1);
    syslog(
        LOG_WARNING, 
        "Don't mess with Adil"
        );
    syslog(
        LOG_NOTICE, 
        "A tree has fallen"
        );
    setlogmask (LOG_UPTO (LOG_DEBUG));
    openlog ("exampleprog", LOG_CONS | LOG_PID | LOG_NDELAY, LOG_LOCAL1);
    syslog(
        LOG_NOTICE, 
        "A tree has fallen"
        );
    writeln("Done");
}
