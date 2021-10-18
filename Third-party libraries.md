2020-08-27_12:24:45

# Third-party libraries

## In-engine third-party libraries

The engine includes several third-party libraries.
They are stored in `$UE_ROOT/Engine/Source/ThirdParty`.
Each has its own `.Build.cs` file, just like any other module.
Unreal Build Tool doesn't build third-party libraries, instead pre-compiled binaries are provided.
The pre-compilation is done with one of
- `BuildThirdPartyLibs` Unreal Automation Tool scripts.
- Batch files or shell scripts.
- Specialized Unreal Automation Tool scripts.
See `BuildThirdPartyLibs.Automation.cs` in `$UE_ROOT/Programs/Automation`.
Have a look at the third-party libraries included with the engine for an idea of how it works.
(
This wasn't very helpful for me. They seem to have a very different built pipeline, with cross compilation and such.
)

If your library depend on a library among the in-engine third-party libraries, then you should link against the one in the engine.
Do not link against binaries you built yourself, that you downloaded from somewhere, or that your package manager provides.
See [Key issues @ docs.adamrehn.com](https://docs.adamrehn.com/conan-ue4cli/read-these-first/introduction-to-conan-ue4cli#key-issues).


## Compiling third-party libraries

On Linux, Unreal Engine ships with a compiler, a C++ standard library implementation, and a set of third-party libraries that should be used when building third-party libraries.
In particular, the system C++ standard library should not be used because of binary incompatibilities.
Different `sizeof(std::function)`, for example, and different mangled names for a few standard library classes and functions.
Unreal Engine is able to automate some of this in some cases.
The following is from the [Unreal Engine 4.25 release notes](https://docs.unrealengine.com/en-US/Support/Builds/ReleaseNotes/4_25/index.html):
```
RunUAT.bat BuildCMakeLib -TargetLib=ExampleLib -TargetLibVersion=examplelib-0.1 -TargetConfigs=relase+debug -TargetPlatform=PlatformName -LibOutputPath=lib -CMakeGenerator=Makefile -CMakeAdditionalArguments="-DEXAMPLE_CMAKE_DEFINE=1" -MakeTarget=all -SkipSubmit
```
I don't know what any of the above means, or what's legal to pass, or what I should pass.
See more detailed analysis in a dedicated subsection titled **BuildCMakeLib** below.

There's also `Engine/Build/BatchFiles/Linux/BuildThirdParty.sh`.
An example parameter list: `-b SDL2`.
For each build target, this script does some setup and then calls whatever build tool that has been configured in the corresponding `$UE_ROOT/Engine/Source/ThirdParty` subdirectory.
It doesn't seem to do any particular Unreal Engine compatible setup on its own.

There is also ue4cli, a Python application designed to, among other things, help with build third-party libraries for Unreal Engine.
It can print the compiler and linker flags required to build for a particular Unreal Engine installation.
[Introduction to ue4cli @ https://docs.adamrehn.com/](https://docs.adamrehn.com/ue4cli/overview/introduction-to-ue4cli)
See more detailed analysis in a dedicated subsection titled **ue4cli** below.

There is also `Engine/Source/Programs/UnrealBuildTool/Platform/Linux/LinuxToolChain.cs`.
This seems to be what does the actual compiler driving on Linux when using Unreal Build Tool.
I don't know if this file is applicable when building third-party libraries.
But at the very least it most likely contains important hints on what one has to do to build third party libraries.

Unreal Engine comes with a set of third-party libraries. 
Most of them built as static libraries.
To prevent invalid symbol interpositions third-party libraries should be built against the third-party libraries shipped with Unreal Engine, whenever such a library exists.
When using the shipped compiler and libraries, compiled binaries will be transferable between Linux distributions and versions.
The compiler is stored at `Engine/Extras/ThirdPartyNotUE/SDKs/HostLinux/Linux_x64/v16_clang-9.0.1-centos7/x86_64-unknown-linux-gnu/`.
Or something similar, depending on Unreal Engine version.
We call this the "compiler directory".
The standard library is stored at `Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/`.
We call this the "LibCxx" directory.

Different versions of Unreal Engine use different versions of Clang:
```
UE4 Version    Toolchain
4.27           v19_clang-11.0.1
4.26           v17_clang-10.0.1
4.25           v16_clang-9.0.1
4.23           v15_clang-8.0.1
4.24           v15_clang-8.0.1
4.22           v13_clang-7.0.1
4.21           v12_clang-6.0.1
4.20           v11_clang-5.0.0
```
These are listed at [Native Toolchain @ docs.unrealengine.com](https://docs.unrealengine.com/4.27/en-US/SharingAndReleasing/Linux/NativeToolchain/) and can also be downloaded from [http://cdn.unrealengine.com/Toolchain_Linux/native-linux-TOOLCHAIN-centos7.tar.gz](http://cdn.unrealengine.com/Toolchain_Linux/native-linux-TOOLCHAIN-centos7.tar.gz)

An old (2016) [presentation](https://www.slideshare.net/GerkeMaxPreussner/plugins-thirdparty-sdks-in-ue4) from Epic Games on third-party libraries had the following to say about Linux:
> Locating libs at runtime: You have to hack LinuxToolchain.cs or use FPlatformProcess::GetDllHandle.
> At some point we will fix this.
> On Linux we always use weak symbol resolution by default!

I'm not sure what any of this means. What do we need to hack in `LinuxToolchain.cs`? Has the thing been fixed yet?

There are a number of flags that can be passed to the compiler and linker to make it use the Unreal Engine compatible standard libraries.

Compile:
```
-nostdinc++
-I $UE_THIRD_PARTY_DIR/Linux/LibCxx/include/
-I $UE_THIRD_PARTY_DIR/Linux/LibCxx/include/c++/v1
```
`-nostdinc++`: Do  not search the standard system directories or compiler builtin directories for include files.
`-I`: Instead, add include paths to the `LibCxx` include files shipped with Unreal Engine.

`ue4cli` says
```
-I$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/include
-I$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/include/c++/v1
-fPIC
-nostdinc++
```
Added `-fPIC`, but otherwise the same.

Link:
```
-nodefaultlibs
-L $UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/
$UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++.a
$UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++abi.a
-lm -lc -lgcc_s -lgcc
```

`-nodefaultlibs`: Do not use standard system libraries when linking.
`-L`: Provide path to where the the Unreal Engine provided C++ standard library is.
`libc++.a`: Direct linking to the Unreal Engine provided C++ standard library.
`libc++abi.a`: Direct linking the Unreal Engine provided support library for the C++ standard library.
`-lm -lc -lgcc_s lgcc`: Link with a bunch of low-level C libraries.

`ue4cli` says
```
-nodefaultlibs
-L$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu
$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++.a
$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++abi.a
-lm
-lc
-lgcc_s
-lgcc
```

Exactly the same.

Notice that there is no mention of the compiler directory here, only the `LibCxx` directory.
It's unclear to me if the low-level C libraries should resolve to system libraries or Unreal Engine provided libraries.
They are NOT included in the `LibCxx` folder.
They are included in the compiler directory.
If the compiler provided ones, how are they supposed to be found?

The answer to the above question may be `sysroot`.
See [CrossCompilation@clang.llvm.org](https://clang.llvm.org/docs/CrossCompilation.html).

The way UnrealBuildTool for a particular Unreal Engine version invokes the compiler can be found in `LinuxToolChain.cs`.
That files is stored at `Engine/Source/Programs/UnrealBuildTool/Platform/Linux/`.

A comment in [ Compiling libraries in Linux@answers.unrealengine.com](https://answers.unrealengine.com/questions/674473/compiling-libraries-in-linux.html) state that `stdlib=libc++` should be used instead of `-nodefaultlibs`.
Otherwise the user gets linker errors on `std::__1::` prefixed symbols, which he or she attributes to `-nostdinc++` not working because `std::__1::` indicates `libstdc++` and not `libc++`.
`libstdc++` is the GCC version of the standard library.
`libc++` is the Clang version, the one used by Unreal Engine.
An Epic Games employee disagrees with the analysis, and says that `-nostdinc++` is not ignored by Clang.

Passing C++ classes between libraries is adviced against.
The third-party library API should preferably be marked `extern "C"`.
C++ types and signatures are ok as long as binary compatibility is maintained between all libraries.
This is the reason why we need to build with the Unreal Engine included compiler tool chain.

Another commenter state that GCC works just fine, i.e., Clang is not required, as long as the Unreal Engine provided `libc++` is used.

One is supposed to be able to use Unreal Build Tool to generate a list of compile commands.
This would be useful to see the full build commands that are generated when building the project source files.
From a Bash shell run:
```
cd ${UE_ROOT}/Engine/Build/BatchFiles/Linux
source SetupMono.sh $(readlink -f .)
cd ${PROJECT_DIR}
mono ${UE_ROOT}/Engine/Binaries/DotNET/UnrealBuildTool.exe -mode=GenerateClangDatabase -Project=${PROJECT_DIR}/${PROJECT_NAME}.uproject MyProjectEditor Linux Debug
```
Should should generate `compile_commands.json`.
For me it errors out with `ERROR: Clang must be installed in order to build this target.`.
A search for `must be installed in order` in `${UE_ROOT}/Engine/Source/Programs` only finds stuff in `UnrealBuildTool/Platform/Windows/VCEnvironment.cs`, which doesn't seem to be what I need.



[NativeToolchain@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Platforms/Linux/NativeToolchain/index.html)  
[ Compiling libraries in Linux@answers.unrealengine.com](https://answers.unrealengine.com/questions/674473/compiling-libraries-in-linux.html)


## BuildCMakeLib

`BuildCMakeLib` is an Unreal Automation Tool that helps with building CMake libraries for Unreal Engine.
I think its designed mainly for the third-party libraries included in the engine since it assumes that both the library sources and resulting binaries are in the engine directory tree.
The source directory can be overridden, but I see no way to do the same for the resulting binary.
Still, we can study it to see what it does.
`BuildCMakeLib` is defined in
```
./Source/Programs/AutomationTool/Scripts/BuildCMakeLib.Automation.cs
```
An example invocation taken from the [Unreal Engine 4.25 release notes](https://docs.unrealengine.com/en-US/Support/Builds/ReleaseNotes/4_25/index.html):
```
RunUAT.bat
    BuildCMakeLib
    -TargetLib=ExampleLib
    -TargetLibVersion=examplelib-0.1
    -TargetConfigs=relase+debug
    -TargetPlatform=PlatformName
    -LibOutputPath=lib
    -CMakeGenerator=Makefile
    -CMakeAdditionalArguments="-DEXAMPLE_CMAKE_DEFINE=1"
    -MakeTarget=all
    -SkipSubmit
```

It has a function named `GetToolchainName` that on Linux returns `Linux.cmake`.
The engine includes `./Extras/ThirdPartyNotUE/CMake/share/cmake-3.5/Modules/Platform/Linux.cmake`.
`Linux.cmake` includes `UnixPaths.cmake`.
The CMake scripts sets a bunch of linker and library executable flags, but all paths I see are system path.
These build scripts seem to be made for a system that is natively compatible with Unreal Engine.
That is,  they don't show how to use the Unreal Engine provided compiler and standard library instead of the system ones.

I don't see any mention of Clang in any of these files, which seems like an important detail to me.


## ue4cli

ue4cli is a tool developed to, among other things, help with building third-party libraries for Unreal Engine.
We are particularly interested in the [library commands @ docs.adamrehn.com](https://docs.adamrehn.com/ue4cli/overview/introduction-to-ue4cli#library-commands).
These commands tell us that flags we need to pass at the various stages of the build pipeline.
They are centered around libraries shipped with Unreal Engine.
So if you need to link against a library shipped by Unreal Engine then you can ask ue4cli what flags you need to do that.
The standard library is considered just another lib, named `libc++`.

`ue4 cmakeflags [LIBS]`

Prints the CMake flags for building a third-party library.
On my machine this prints the following, somewhat edited, for `LIBS=libc++`:
```
-DCMAKE_PREFIX_PATH=
-DCMAKE_INCLUDE_PATH=
    $UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/include;
    $UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/include/c++/v1;
-DCMAKE_LIBRARY_PATH=
    $UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu
```

`ue4 cxxflags [LIBS]`

Prints the compiler flags for building a third-party library.
On my machine this prints the following, somewhat edited, for `LIBS=libc++`:
```
-I$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/include
-I$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/include/c++/v1
-fPIC
-nostdinc++
```
In the actual output each line was printed twice. Avoided by adding `--nodefaultlibs`.

`ue4 defines [LIBS]`

Prints the preprocessor definitions for building a library.
On my machine this prints the following for `LIBS=libc++`:
```

```
That's the empty string.

`ue4 includedirs [LIBS]`

Prints the include directories for a library.
On my machine this prints the following, somewhat edited, for `LIBS=libc++`:
```
$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/include
$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/include/c++/v1
```

`ue4 ldflags [LIBS]`

Prints the linker flags to use when building against a third-party library.
On my machine this prints the following, somewhat edited, for `LIBS=libc++`:
```
-nodefaultlibs
-L$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu
$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++.a
$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++abi.a
-lm
-lc
-lgcc_s
-lgcc
```

`ue4 libfiles [LIBS]`

Prints the library files for the given libraries.
On my machine this prints the following, somewhat edited, for `LIBS=libc++`.
```
$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++.a
$UE_ROOT/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++abi.a
-lm
-lc
-lgcc_s
-lgcc
```

This is the same as `ldflags`, except for `-nodefaultlibs` and `-L`.


## Including third-party libraries

Third-party libraries shipped with Unreal Engine are stored in `UnrealEngine/Engine/Source/ThirdParty/`.
Build scripts for those can be studied to understand more of the build process.

Just like any module, each third-party library needs a `.Build.cs` file.
For third-party libraries the `.Build.cs` file doesn't describe how to build the library but only how to integrate it with the modules built by Unreal Build Tool.
The third-party library itself is built separately using whatever build system the library itself is using.
Set the `Type` member variable to `ModuleType.External` to signal that it is an external library.
Unreal Build Tool will perform no compilation for external libraries.
Any preprocessor defines that the library needs can be added to `PublicDefinitions`.
Any include paths that the library needs can be added to `PublicIncludePaths`.
Any other libraries that the library needs can be added to `PublicAdditionalLibraries`.
Add paths to directories containing additional libraries to `PublicAdditionalLibraries`.
The `Private` versions of those lists make no sense for external libraries since UnrealBuildTool doesn't build this module.
It's unclear to me what the semantics of these lists are during packaging/shipping.
Will the include directories and the other libraries be included?
By adding libraries to `RuntimeDependencies` it will be copied next to the executable when packaging.
This assumes that the library already exists and that the plugin will manually load it.
`RuntimDependencies` can also be used to copy libraries at built time, not just packaging, using a separate overload.

UnrealBuildTool will set `RPATH` for each module.
Not sure what that means in this case. Will `RPATH` be set to the third party library on all modules that use it?
Or is it set on the third party library somehow? Where exactly, if that's the case? Some kind of wrapper library?
This can be checked with `readelf`.
Third-party modules are first loaded with `RTLD_LAZY | RTLD_LOCAL` and then reloaded with `LAZY | RTLD_GLOBAL`.
Don't know why, but it can lead to duplicated symbols and crashses.

To add a third-party library to a module, do:
```csharp
PublicIncludePaths.Add('AbsolutePath/to/include/files');
PublicAdditionalLibraries.Add('AbsolutePath/to/mylib.dll');
```
in a `.Build.cs` file that has `Type` set to `ModuleType.External`.

There are functions to help with generating absolute paths:
```csharp
var base_path = Path.GetFullPath(
    Path.Combine(
        Path.GetDirectoryName(RulesCompiler.GetModuleFilename(this.GetType().Name)),
        "../../mysql"));
 var includes = Path.Combine(base_path, "include");
```

[How do I add thirdparty library?@answers.unrealengine.com](https://answers.unrealengine.com/questions/218616/how-do-i-add-thirdparty-library.html)




One answer state that symbols imported from a third-party library is only visible to that library.
Also advice against linking agains third-party dynamic libraries, and advocate for static libraries instead.
[How do you statically link an external DLL/dylib to your project?@answers.unrealengine.com](https://answers.unrealengine.com/questions/197667/how-do-you-statically-link-an-external-dlldylib-to.html)

## Troubleshooting



## Example use case: OpenEXR

OpenEXR is a third-party library used by Unreal Engine.
Stored in `Engine/Source/ThirdParty/openexr/`.
OpenEXR is a C++ library.
OpenEXR is a Makefile project.
It consists of two parts: `ilmbase` and `openexr`.
Epic Games provides a `BuildOpenEXR.sh` script.
Let's look at the important lines, part for part.
First the common lines:
```
export CXX=clang++
```
They build with their system clang.

The for `imlmbase`:
```
CXXFLAGS="
    -O2 -fPIC -nostdinc++
    -I$UE_THIRD_PARTY_DIR/Linux/LibCxx/include
    -I$UE_THIRD_PARTY_DIR/Linux/LibCxx/include/c++/v1"
LDFLAGS="
    -nodefaultlibs
    -L$UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/
    $UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++.a
    $UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++abi.a
    -lm -lc -lgcc_s -lgcc"
./configure --prefix=$TEMP_DIR
make install
```
`CXXFLAGS` is set to:
- Not include system C++ standard library headers
- Add the `LibCxx` shipped with Unreal Engine instead.

`LDFLAGS` is set to:
- Not link with system standard libraries.
- Search for libraries in `LibCxx` shipped with Unreal Engine.
- Link with `libc++.a` and `libc++abi.a` in `LibCxx` shipped with Unreal Engine.
- Link with `m`, `c`, `gcc_s` and `gcc` using the normal library resolution rules.

The following searches was performed with `find . -regextype awk -regex '.*/lib<LIB_NAME>\.(so|a).*'` from `<UE_ROOT>/Engine`.

`libm` exists as both `libm.so` and `libm.a` in both `usr/lib64` and `usr/lib` in the Unreal Engine compiler directory.
`libm` also exists as `libm.so.6` in `lib64` in the compiler directory.
None of these are symlinks.

`libc` exists as both `libc.a` and `libc.so` in both `usr/lib64` and `usr/lib` in the Unreal Engine compiler directory.
`libc` also exists as `libc.so.6` in `lib64` in the compiler directory.
None of these are symlinks.

`libgcc_s` exists as `libgcc_s.so` and `libgcc_s.so.1` in the Unreal Engine compiler directory.
None of these are symlinks.

`libgcc` exists as `libgcc.a` in `lib/gcc/x86_64-unknown-linux-gnu/4.8.5/` in the compiler directory.

All of the above also exists in one of more of the system library directories `/usr/lib/x86_64-linux-gnu/`, `/lib/x86_64-linux-gnu/`,  `/lib/x86_64-linux-gnu/`, and `/usr/lib/gcc/x86_64-linux-gnu/7/`.

It's unclear to me which of these, the Unreal Engine compiler versions or the system versions, that should be used.
There is nothing in the build script that indicate that the Unreal Engine compiler versions should be used.
But I guess they are the same on their build machines.
So what should I do on my machine?

Then for the `openexr` part:
```
cd openexr-1.7.1
CXXFLAGS="
    -O2 -fPIC -nostdinc++
    -I$UE_THIRD_PARTY_DIR/Linux/LibCxx/include
    -I$UE_THIRD_PARTY_DIR/Linux/LibCxx/include/c++/v1"
LDFLAGS="
    -nodefaultlibs
    -L$UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/
    $UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++.a
    $UE_THIRD_PARTY_DIR/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/libc++abi.a
    -lm -lc -lgcc_s -lgcc"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$TEMP_DIR/lib"
./configure --with-ilmbase-prefix=$TEMP_DIR --prefix=$TEMP_DIR
make install
```
Pretty much the same as the `ilmbase` part, but also passing in the path to where `ilmbase` was installed.

## Example use case: FreeType2

This is a third-party library used by Unreal Engine.
Stored in `Engine/Source/ThirdParty/FreeType2`.
Freetype2 is a C library.
FreeType2 is a CMake project.
Or rather, they supply a CMakeLists.txt but that's not the main way of building the library.
Epic Games provides a `BuildForLinux.sh` script.
Let's look at the most important parts:
```
cmake
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_PREFIX_PATH="
        $UE_THIRD_PARTY_DIR/libPNG/libPNG-1.5.2/lib/Linux/x86_64-unknown-linux-gnu;
        $UE_THIRD_PARTY_DIR/libPNG/libPNG-1.5.2";
        $UE_THIRD_PARTY_DIR/zlib/v1.2.8/lib/Linux/x86_64-unknown-linux-gnu" 
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON 
    -DCMAKE_C_COMPILER=clang 
    -DCMAKE_C_FLAGS="-ffunction-sections -fdata-sections"
    "$BASE_DIR"

make -j4
cp -v libfreetype.a "$BASE_DIR/lib/Linux/$ARCH/libfreetype_fPIC.a"
```
The script does nothing with custom standrad libraries or the packaged compiler.
Why not?
`Expat` is another third-party C/CMake library that seem to just straight up run CMake/Make.


[[2020-09-10_19:55:50]] [Modules](./Modules.md)  
[[2020-09-15_17:27:33]] [Plugins](./Plugins.md)  
[[2020-08-13_08:37:17]] [Building plugins](./Building%20plugins.md)  
[[2020-08-26_08:28:16]] [Build systems](./Build%20systems.md)  

[ThirdPartyLibraries@https://docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/ThirdPartyLibraries/index.html)  
[Introduction To Conan-UE4CLI@https://docs.adamrehn.com](https://docs.adamrehn.com/conan-ue4cli/read-these-first/introduction-to-conan-ue4cli)  
