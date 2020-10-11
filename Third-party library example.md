2020-09-20_10:40:25

# Third-party library example

This page describe a complete third-party library integration into an Unreal Engine plugin.
The library is a simple mock library that has the following problematic properties:
- Has a dependency of its own.
- Makes use of C++ classes in its public interface.
- Throws exceptions from inline functions.
- Uses runtime type information in public headers
- Calls functions from both the C and C++ standard libraries, both in inline functions in the header files and in the source files.

The library is called `api`.
Its dependency is called `core`.

CMake is used to build both the third-party library and its dependency.

The file system structure for `core`:
```
core/repository
├── CMakeLists.txt
├── include
│   └── core.hpp
└── source
    └── core.cpp
```

Simplest possible, a `CMakeLists.txt` to define the library, a `core.hpp` for the public interface, and `core.cpp` for the private implementation. As we shall see, a bunch of implementation code has been put into `core.hpp` in order to make it more problematic for the Unreal Engine integration.

`CMakeLists.txt`:
```cmake
cmake_minimum_required(VERSION 3.10)
project(core LANGUAGES CXX VERSION 1.0)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library("core" SHARED "source/core.cpp")
target_include_directories("core" PUBLIC "include")
install(TARGETS "core" DESTINATION "lib")
install(DIRECTORY "include/" DESTINATION "include/core")
```

The `CMakeLists.txt` project definition creates a single C++11 shared library named `core`. The compiled library binary is installed to `lib` and the header files to `include/core`.

`core.hpp`:
```c++
#pragma once

#include <functional>
#include <set>
#include <string>

namespace core
{
  enum class CallbackContinuation
  {
    CONTINUE,
    BREAK,
    TERMINATE
  };

  class Callback
  {
  public:
    template<typename Func>
    Callback(int priority, Func callback)
      : m_priority(priority)
      , m_callback(callback)
    {
    }

    CallbackContinuation operator()(const char*);

    int getPriority() const
    {
      return m_priority;
    }

  private:
    int m_priority;
    std::function<CallbackContinuation(const char*)> m_callback;
  };

  bool operator<(Callback const& lhs, Callback const& rhs)
  {
    return lhs.getPriority() < rhs.getPriority();
  }

  void addErrorCallback(Callback callback);

  using Callbacks = std::multiset<Callback>;
  const Callbacks& getErrorCallbacks();

  void signalError(const char* message)
  {
    for (auto callback : getErrorCallbacks())
    {
      CallbackContinuation continuation = callback(message);
      switch (continuation)
      {
        case CallbackContinuation::CONTINUE:
          // Move on to the next callback.
          break;
        case CallbackContinuation::BREAK:
          goto after_loop;
        case CallbackContinuation::TERMINATE:
          std::terminate();
      }
    }
  after_loop:
    return;
  }

  void consume(volatile char* memory, size_t numBytes);

  std::string getFullName(std::string givenName, std::string familyName);
}
```

The `core` header file contains code making use of C++ standrad library classes, class templates, function templates, and inline functions that makes calls to C++ standard library functions.

`core.cpp`:
```c++
#include "core.hpp"
#include "consume.hpp"
#include <iostream>
#include <cfenv>

namespace
{
  core::Callbacks s_errorCallbacks;
}

core::CallbackContinuation core::Callback::operator()(const char* message)
{
  return m_callback(message);
}

void core::addErrorCallback(Callback callback)
{
  s_errorCallbacks.insert(callback);
}

const core::Callbacks& getErrorCallbacks()
{
  return s_errorCallbacks;
}


std::string core::getFullName(std::string givenName, std::string familyName)
{
  int roundMode = fegetround();
  switch (roundMode)
  {
    case FE_DOWNWARD: std::cout << "DOWN\n"; break;
    case FE_TONEAREST: std::cout << "NEAREST\n"; break;
    case FE_TOWARDZERO: std::cout << "ZERO\n"; break;
    case FE_UPWARD: std::cout << "UP\n"; break;
    default: std::cout << "UNKNOWN\n"; break;
  }

  if (givenName.empty())
  {
    core::signalError("Empty given name.");
  }
  if (familyName.empty())
  {
    core::signalError("Empty family name.");
  }

  std::string fullName = givenName + " " + familyName;
  size_t numChars = fullName.size();
  size_t numBytes = numChars + 1;
  char* buffer = (char*)malloc(numBytes);
  memcpy(buffer, fullName.data(), numChars);
  buffer[numChars] = '\0';
  size_t length = strlen(buffer);
  consume(buffer, length);
  free(buffer);
  return fullName;
}

volatile char store;

void core::consume(volative char* memory, size_t numBytes)
{
  for (size_t i = 0; i < numBytes; ++i)
  {
    store = memory[i];
  }
}
```

The `core` source file contains manipulations of C++ standard library classes, calls to C standard library functions, and usage of `std::cout`.

The file system structure for `api`:
```
api/repository
├── CMakeLists.txt
├── include
│   └── api.hpp
└── source
    └── api.cpp
```

The file system structure `api` is very similar to `core`, there is a 1:1 mapping for each file.

`CMakeLists.txt`:
```cmake
cmake_minimum_required(VERSION 3.10)

project(api LANGUAGES CXX VERSION 1.0)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library("api" SHARED "source/api.cpp")
target_include_directories("api" PUBLIC "include")

find_library(core_library  "core" REQUIRED)
target_link_libraries("api" ${core})

find_file(core_header "core/core.hpp" REQUIRED)
get_filename_component(core_include "${core_header}" DIRECTORY)
get_filename_component(core_include "${core_include}" DIRECTORY)
target_include_directories("api" PUBLIC ${core_include})

install(TARGETS "api" DESTINATION "lib")
install(DIRECTORY "include/" DESTINATION "include/api")
```

The `api` `CMakeLists.txt` file is similar to the one in `core`. It also creates a single C++ shared library. The biggest difference is that it finds and uses the `core` library. It does this with manual `find_(library|file)` calls and `target_(link_libraries|include_directories)` instead of `find_package` because I want to keep the example short. The two `get_filename_component` calls  are there to strip away first `core.hpp` and then `core`  in order to the root of `core`'s installed `include` directory.

`api.hpp`:
```c++
#pragma once
#include "core/core.hpp"
#include <stdexcept>
#include <string>
#include <typeinfo>
#include <cstdio>

namespace api
{
  class Person
  {
  public:
    Person(std::string giveName, std::string familyName);
    std::string getFullName() const;
  private:
    std::string m_givenName;
    std::string m_familyName;
  };

  struct PersonId
  {
    int id;
  };

  PersonId addPerson(Person person);
  Person getPerson(PersonId id);

  template<typename T>
  bool isPerson(T* object)
  {
    return dynamic_cast<Person*>(object) != nullptr;
  }

  template<typename T>
  Person* asPerson(T* object)
  {
    if (!isPerson(object))
    {
      fprintf(stderr, "Invalid type: %s.", typeid(T).name());
      core::signalError("Invalid type.");
      throw std::runtime_error("Invalid type");
    }
    return dynamic_cast<Person*>(object);
  }
}
```

`api.hpp` makes use of `dynamic_cast`, `typeid` and exceptions.

`api.cpp`:
```c++
#include "api.hpp"

#include "core/core.hpp"

#include <stdexcept>
#include <vector>

using namespace api;

Person::Person(std::string givenName, std::string familyName)
  : m_givenName(givenName)
  , m_familyName(familyName)
{
}

std::string Person::getFullName() const
{
  return core::getFullName(m_givenName, m_familyName);
}

namespace
{
  std::vector<Person> s_persons;
};

PersonId api::addPerson(Person person)
{
  int id = s_persons.size();
  s_persons.push_back(person);
  return {id};
}

Person api::getPerson(PersonId personId)
{
  int id = personId.id;
  if (id < 0 || id >= s_persons.size())
  {
    fprintf(stderr, "Unknown person id: %d.", id);
    core::signalError("Unknown person id.");
    throw std::runtime_error("Unknown person id.");
  }

  return s_persons[id];
}
```

`api.cpp` doesn't bring much new complicating feature use. It's there just for the logic of the library to work.

Bash scripts are used to build the two libraries, with the `build` directories placed next to each library's `repository` directory. A root level build script invokes the two library build scripts.

Root `build.bash`:
```bash
#!/bin/bash

set -e

echo -e "\n\n  Building core."
cd core
./build.bash
cd ..

echo -e "\n\n  Building api."
cd api
./build.bash
cd ..
```

Not much exiting going on here, just call the two build scripts in their respecitve directories.

`core`'s `build.bash`:
```bash
#!/bin/bash

set -e

echo "  Generating project files."
if [ ! -d build ] ; then
    mkdir build
    cd build
    cmake \
        ../repository/ \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="../../installed/core" \
        -DCMAKE_TOOLCHAIN_FILE="../../unreal/ue-toolchain.cmake"
else
    cd build
    cmake .
fi


echo "  Building."
ninja

echo "  Installing."
ninja install
```

In `core`'s build script it worth pointing out that we install to `installed/core` and that we make use of a `CMAKE_TOOLCHAIN_FILE`. A toolchain file is a CMake script that is run by CMake very early in its setup process. Here is where we can configure fundamental things such as which compiler to use and which standard library implementation to use. The toolchain should only be specified the first time CMake is run for a project. We will have a look at the contents of `ue-toolchain.cmake`
 shortly.

`api`'s `build.bash`:
```bash
#!/bin/bash

set -e

echo "  Generating project files."
if [ ! -d build ] ; then
    mkdir build
    cd build
    cmake \
        ../repository/ \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH="../../installed/core/" \
        -DCMAKE_INSTALL_PREFIX="../../installed/api" \
        -DCMAKE_TOOLCHAIN_FILE="../../unreal/ue-toolchain.cmake"
else
    cd build
    cmake .
fi

echo "  Building."
ninja

echo "  Installing."
ninja install
```

`api`'s build script is almost identical to `core`'s. There are two important differences. The first is that we install to `installed/api` instead of `installed/core`. The second is that we set `CMAKE_PREFIX_PATH` to `core`'s install directory. This is how we make `find_library` and `find_file` in `api`'s `CMakeLists.txt` find the library and header files installed by `core`.

`ue-toolchain.cmake`:
```cmake
if("${UE_ROOT}" STREQUAL "")
  set(UE_ROOT "$ENV{UE_ROOT}")
endif()

if("${UE_ROOT}" STREQUAL "")
  message(FATAL_ERROR "UE_ROOT has not been set.")
endif()

set(ue_libcxx_dir "${UE_ROOT}/Engine/Source/ThirdParty/Linux/LibCxx")
set(ue_compiler_subdir "Engine/Extras/ThirdPartyNotUE/SDKs/HostLinux/Linux_x64")
set(ue_compiiler_name "v16_clang-9.0.1-centos7") # Varies with UE version.
set(ue_compiler_dir "${UE_ROOT}/${ue_compiler_subdir}/${ue_compiler_name}/x86_64-unknown-linux-gnu/")

set(CMAKE_C_COMPILER "${ue_compiler_dir}/bin/clang" CACHE STRING "The C compiler to use.")
set(CMAKE_CXX_COMPILER "${ue_compiler_dir}/bin/clang++" CACHE STRING "The C++ compiler to use.")
set(CMAKE_SYSROOT "${ue_compiler_dir}")

# Add compiler flags to use the standrad library header files shipped with Unreal Engine.
set(ue_compiler_flags -nostdinc++ -I${ue_libcxx_dir}/include -I${ue_libcxx_dir}/include/c++/v1)
add_compile_options("$<$<COMPILE_LANGUAGE:CXX>:${ue_compiler_flags}>")

set(ue_linker_flags "-nodefaultlibs -L${ue_libcxx_dir}/lib/Linux/x86_64-unknown-linux-gnu/")
if(NOT CMAKE_SHARED_LINKER_FLAGS MATCHES "${ue_libcxx_dir}")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ue_linker_flags}" CACHE INTERNAL "")
endif()

set(CMAKE_C_STANDARD_LIBRARIES "-lm -lc -lgcc_s -lgcc" CACHE INTERNAL "")
set(CMAKE_CXX_STANDARD_LIBRARIES "${ue_libcxx_dir}/lib/Linux/x86_64-unknown-linux-gnu/libc++.a ${ue_libcxx_dir}/lib/Linux/x86_64-unknown-linux-gnu/libc++abi.a -lm -lc -lgcc_s -lgcc -lpthread" CACHE INTERNAL "")

set(CMAKE_SIZEOF_VOID_P 8 CACHE INTERNAL "")
```

There is a lot going on here so let's take it bit by bit.

```cmake
if("${UE_ROOT}" STREQUAL "")
  set(UE_ROOT "$ENV{UE_ROOT}")
endif()

if("${UE_ROOT}" STREQUAL "")
  message(FATAL_ERROR "UE_ROOT has not been set.")
endif()
```

We will be using the compiler and standard libraries shipped with Unreal Engine and in order to do that we need to know which Unreal Engine installation to use. We use the `UE_ROOT` variable, and initialize it from the environment variable with the same name if necessary.

```cmake
set(ue_libcxx_dir "${UE_ROOT}/Engine/Source/ThirdParty/Linux/LibCxx")
set(ue_compiler_subdir "Engine/Extras/ThirdPartyNotUE/SDKs/HostLinux/Linux_x64")
set(ue_compiiler_name "v16_clang-9.0.1-centos7") # Varies with UE version.
set(ue_compiler_dir "${UE_ROOT}/${ue_compiler_subdir}/${ue_compiler_name}/x86_64-unknown-linux-gnu/")
```

The above snippet of code unitializes a few helper variables to a pair of useful directories within the Unreal Engine installation, one for the C++ standard library and one for the compiler.

```
set(CMAKE_C_COMPILER "${ue_compiler_dir}/bin/clang" CACHE STRING "The C compiler to use.")
set(CMAKE_CXX_COMPILER "${ue_compiler_dir}/bin/clang++" CACHE STRING "The C++ compiler to use.")
set(CMAKE_SYSROOT "${ue_compiler_dir}")
```

Here we tell CMake that we want to use `clang` and `clang++` as the C and C++ compiler to use for this project. We pass the full path to the binaries in the Unreal Engine installation. We also set `CMAKE_SYSROOT`, which CMake translates into a `--sysroot` parameter, so that the compiler will use its own system libraries and include files. This does not change the C++ standard library, which is the next step.

```cmake
set(ue_compiler_flags -nostdinc++ -I${ue_libcxx_dir}/include -I${ue_libcxx_dir}/include/c++/v1)
add_compile_options("$<$<COMPILE_LANGUAGE:CXX>:${ue_compiler_flags}>")
```

This adds compiler options for all source files that are compiled with the C++ compiler so that they are compiled in C++11 mode without the system's standard include files but with include files from the C++ standard library shipped with Unreal Engine.

Next we de the same thing for libraries.

```cmake
set(ue_linker_flags "-nodefaultlibs -L${ue_libcxx_dir}/lib/Linux/x86_64-unknown-linux-gnu/")
if(NOT CMAKE_SHARED_LINKER_FLAGS MATCHES "${ue_libcxx_dir}")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ue_linker_flags}" CACHE INTERNAL "")
endif()
```

This adds linker flags for all shared libraries, one can do the same for executables, static libraries, and modules, so that they do not link with the default libraries and do search for linked libraries among the libraries included in the standard library implementation shipped with Unreal Engine.

```cmake
set(CMAKE_C_STANDARD_LIBRARIES "-lm -lc -lgcc_s -lgcc" CACHE INTERNAL "")
set(CMAKE_CXX_STANDARD_LIBRARIES "${ue_libcxx_dir}/lib/Linux/x86_64-unknown-linux-gnu/libc++.a ${ue_libcxx_dir}/lib/Linux/x86_64-unknown-linux-gnu/libc++abi.a -lm -lc -lgcc_s -lgcc -lpthread" CACHE INTERNAL "")
```
We're getting close to the end now. In the above we specify which libraries should constitue standard libraries. For C this includes `m`; the standard math library, `c`; the standard C library, `gcc_s`; the shared library version of the GCC system utitities, and `pthread`.

``` cmake
set(CMAKE_SIZEOF_VOID_P 8 CACHE INTERNAL "")
```

The complete source+build tree:
```
.
├── api
│   ├── build
│   │   ├── build.ninja
│   │   ├── CMakeCache.txt
│   │   ├── CMakeFiles
│   │   └── rules.ninja
│   ├── build.bash
│   └── repository
│       ├── CMakeLists.txt
│       ├── include
│       │   └── api.hpp
│       └── source
│           └── api.cpp
├── build.bash
├── core
│   ├── build
│   │   ├── build.ninja
│   │   ├── CMakeCache.txt
│   │   ├── CMakeFiles
│   │   └── rules.ninja
│   ├── build.bash
│   └── repository
│       ├── CMakeLists.txt
│       ├── include
│       │   └── core.hpp
│       └── source
│           └── core.cpp
```


After building and installing we get an install tree with the following contents:
```
installed/
├── api
│   ├── include
│   │   └── api
│   │       └── api.hpp
│   └── lib
│       └── libapi.so
└── core
    ├── include
    │   └── core
    │       └── core.hpp
    └── lib
        └── libcore.so
```

Notice that `core` and `api` are completely separate, with their own `include` and `lib` directories.

