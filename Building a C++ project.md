2020-10-02_12:42:00

# Building a C++ project

How a project is built depends on the type of project files that has been generated for it.
`Makefile` projects are built by running `make <ProjectName>Editor` for an editor build and `make <ProjectName>` for a game build.
`CMake` projects are built by first creating a new directory for the project files, `cmake-build` for example, and in that directory run`cmake ..`.  After that you have a `Makefile` that can be used as above.

All the variants above all ultimately reach the build scripts shipped with Unreal Engine.
These can be invoked manually.
`<UnrealRoot>/Engine/Build/BatchFiles/Linux/Build.sh <ProjectName> Linux Development -project=<UnrealProjectsDir>/<ProjectName>/<ProjectName>.uproject -game -progress -buildscw"`
