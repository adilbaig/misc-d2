import core.sys.linux.epoll;
import std.stdio;

void main()
{
    epoll_create(40);
    writeln("epoll imported", EPOLL_CLOEXEC);
}