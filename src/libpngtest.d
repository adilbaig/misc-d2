module libpngtest;

import std.stdio;
import std.conv;
import core.sys.posix.dlfcn;
import std.c.linux.linux;

alias uint function() png_access_version_number_t;

int main() {
  auto lib = dlopen("libpng.so".ptr, RTLD_LAZY | RTLD_LOCAL);
  if (lib is null) {
    writeln("EEEK!");
  writeln(to!string(dlerror()));
  return -1;
  } else {
    writeln("WOOT!");
    auto png_access_version_number = cast(png_access_version_number_t)dlsym(lib, "png_access_version_number");
    writeln(png_access_version_number());
  }

  if (dlclose(lib) == 0) {
    return 0;
  } else {
    return -1;
  }
} // main() function

// compile: dmd libpngtest.d -L-ldl
// run:     ./libpngtest