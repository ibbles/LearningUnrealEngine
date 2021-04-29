2020-10-02_12:42:00

# Building a C++ project

How a project is built depends on the type of project files that has been generated for it.
`Makefile` projects are built by running `make <ProjectName>Editor` for an editor build and `make <ProjectName>` for a game build.
Debug builds are built by adding `-Linux-Debug` to the end.
`CMake` projects are built by first creating a new directory for the project files, `cmake-build` for example, and in that directory run`cmake ..`.  After that you have a `Makefile` that can be used as above.

```
make <ProjectName>
make <ProjectName>Editor
make <ProjectName>-Linux-Debug
make <ProjectName>Editor-Linux-Debug
```
We clean the project from build files by passing `ARGS="-clean"'` to make.
```
make <ProjectName> ARGS="-clean"
```

All the variants above all ultimately reach the build scripts shipped with Unreal Engine.
These can be invoked manually.
Here are a few variants that I've seen recommended:
- `<UnrealRoot>/Engine/Build/BatchFiles/Linux/Build.sh <ProjectName> Linux Development -project=<UnrealProjectsDir>/<ProjectName>/<ProjectName>.uproject -game -progress -buildscw"`
- `<UnrealRoot>/Engine/Build/BatchFiles/Linux/Build.sh <ProjectName>Editor Linux Development -Project=<PATH TO UPROJECT>`

One can also run `UnrealBuildTool` directly.
Not sure if this works as-is on Linux, or if something mono-related must be done as well.
Compare with the contents of the build scripts to make sure, I guess they end up with a similar command line at the end.
- `<UnrealRoot>/Engine/Binaries/DotNET/UnrealBuildTool.exe Development Linux -Project="projectpath.uproject" -TargetType=Editor -Progress -NoEngineChanges -NoHotReloadFromIDE`