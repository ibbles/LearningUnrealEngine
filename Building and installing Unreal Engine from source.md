2020-08-22_22:55:03

# Building and installing Unreal Engine from source


## Building step-by-step
The build steps are:
- `mkdir UnrealEngine_<VERSION>`
- `cd UnrealEngine_<VERSION>`
- `git clone https://github.com/EpicGames/UnrealEngine.git .`
- `git checkout <VERSION>-release`
- `./Setup.sh`
- `./GenerateProjectFiles.sh`
- `make`
- `./Engine/Binaries/Linux/UE4Editor`

The last step is to build shaders.
The full process about an hour on my 2017 machine.

Unreal Engine uses UnrealBuildTool to build itself and Unreal Engine projects.
`BuildConfiguration.cs` is the ground-truth for user-configurable build options.
Stored at `./Engine/Source/Programs/UnrealBuildTool/Configuration/BuildConfiguration.cs`.


## Modules
The primary building block in the build process is a module.
A project or a plugin consists of one or more modules.
The engine itself also comes with a bunch of modules.
Each module provide some set of functionality to the project.
A module consists of a number of `.h` and `.cpp` files that implement the fuctionality.
Each module has a `<MODULE>.Build.cs` file.
The `<Module>.Build.cs` file is stored in the `Source` directory,  with the `.h` and `.cpp` files it relates to.
The `Build.cs` file specifies how the module is built, its environment.
This includes module dependencies, other libraries, include paths, etc.
These can be public, meaning that modules using this module get them as well.
The `<MODULE>.Build.cs` file contains a class deriving from the`ModuleRules` class.
The module properties are configured in the  class' constructor.
En example `MyModule.Build.cs` file:
```csharp
using UnrealBuildTool;
using System.Collections.Generic;
public class MyModule : ModuleRules
{
    public MyModule(ReadOnlyTargetRules Target) : base(Target)
    {
        // Settings go here
    }
}
```
Example properties:
- **Type** `ModuleType` Type of module.
    `Editor`, `Game`, or `External`. `External` is used for thid-party libraries[[20200827122445]].
- **PublicIncludePathModuleNames** `List<String>` List of modules names (no path needed) with header files that our module's public headers needs access to, but we don't need to "import" or link against.
- **PublicDependencyModuleNames** `List<String>` List of public dependency module names (no path needed) (automatically does the private/public include). These are modules that are required by our public source files.
- **PrivateDependencyModuleNames** `List<String>`List of private dependency module names. These are modules that our private code depends on but nothing in our public include files depend on.
- **PrivateIncludePathModuleNames** `List<String>` List of modules name (no path needed) with header files that our module's private code files needs access to, but we don't need to "import" or link against.
- **PublicSystemIncludePaths** `List>String>`List of system/library include paths - typically used for External (third party) modules. These are public stable header file directories that are not checked when resolving header dependencies.
- **PrivateIncludePaths** `List>String` List of all paths to this module's internal include files, not exposed to other modules (at least one include to the 'Private' path, more if we want to avoid relative paths).
- **PublicSystemLibraryPaths** `List>String>`List of system library paths (directory of .lib files) - for External (third party) modules please use the PublicAdditionalLibaries instead.
- **PrivateRuntimeLibraryPaths** `List>String>`List of search paths for libraries at runtime (eg. .so files).
- **PublicRuntimeLibraryPaths** `List>String>`List of search paths for libraries at runtime (eg. .so files).
- **PublicAdditionalLibraries** `List>String>` List of additional libraries (names of the .lib files including extension) - typically used for External (third party) modules.
- **PublicSystemLibraries** `List>String>` List of system libraries to use - these are typically referenced via name and then found via the system paths. If you need to reference a .lib file use the PublicAdditionalLibraries instead.
- **PrivateDefinitions** `List<String>` Private compiler definitions for this module.
- **PublicDefinitions** `List<String>` Public compiler definitions for this module.
- **DynamicallyLoadedModuleNames** `List<String>` Addition modules this module may require at run-time.
- **RuntimeDependencies** `RuntimeDependencyList` List of files which this module depends on at runtime. These files will be staged along with the target.
- **ExternalDependencies** `List<String>` External files which invalidate the makefile if modified. Relative paths are resolved relative to the .build.cs file.
- **PCHUsage** `(Not listed in documentation)`Can be set to `PCHUsageMode.UseExplicitOrSharedPCHs` when using IWYU.
- **bEnforceIWYU** `Boolean` Enforce "include what you use" rules when PCHUsage is set to ExplicitOrSharedPCH; warns when monolithic headers (Engine.h, UnrealEd.h, etc...) are used, and checks that source files include their matching header first.
- **CppStandard** `CppStandardVersion` Which stanard to use for compiling this module.
- **ModuleSymbolVisibility** `SymbolVisibility` Control visibility of symbols.
- **bUseRTTI** `Boolean` Use run time type information.  
    Set this to `true` when using a third-party library that require runtime type information. Cannot be used in modules that include types inheriting from engine `U` types.
- **bEnableExceptions** `Boolean` Enable exception handling.  
      Set this to `true` when using a third-party library that throws exceptions. Can this be enabled on any module?

Each module becomes a dynamically linked library, by default.
A monolithic build can be specified in the `BuildConfiguration.cs` file.
Not sure if this is set by changing `BuildConfiguration.cs`, or if `BuildConfiguration.cs` has options for it.

[UnrealBuildTool@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/index.html)  
[ModuleFiles@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/ModuleFiles/index.html)  


## Third-party libraries

Just like regular C++ modules, third party libraries are introduced to the Unreal Build Tool with a `.Build.cs` file.
By setting `Type` to `ModuleType.External` we signal that no compilation is required for this module.
Dependent modules will still get compiler and liker flags that result from options we set in the `.Build.cs` file.
Such as added include paths, setting macros/defines, and linking against libraries.
The `Build.cs` files should be in one of the `Source` folders for the project, optionally in a `ThirdParty` subdirectory.
`RuntimeDependencies` is a list of third-party dynamic libraries that is copied when the project is packaged. the library must already exist.

An example third-party library `Build.cs`:
```csharp
using System;
using System.IO;
using UnrealBuildTool;

public class MyThirdPartyLibrary : ModuleRules
{
    public MyThirdPartyLibrary(ReadOnlyTargetRules Target) : base(Target)
    {
        Type = ModuleType.External;

        // Add any macros that need to be set
        PublicDefinitions.Add("WITH_MYTHIRDPARTYLIBRARY=1");

        // Add any include paths for the plugin
        PublicIncludePaths.Add(Path.Combine(ModuleDirectory, "inc"));

        // Add any import libraries or static libraries
        PublicAdditionalLibraries.Add(Path.Combine(ModuleDirectory, "lib", "foo.a"));
    }
}
```


Note on macOS, but I guess the rule applies to all platforms:  
> [UnrealBuildTool](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/index.html) will automatically add`RPATH`search paths to the executable and dylibs it builds for all the third-party dylibs that are outside of`Engine/Source`and`MyProject/Source`subfolders. Storing third-party dylibs in`Source`subfolders is supported, but not recommended, as these folders are not part of the packaged game or binary version of the plugin, so the build system needs to handle them differently, copy them to a different location, among other things.

[ThirdPartyLibraries@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/ThirdPartyLibraries/index.html)  


## Third-party build system project files
The build system is self-contained and independent of any third-party build system specific project files.
For example Visual Studio's `.sln` files, `CMakeLists.txt`, or `Makefile`.
Project files for a particular third-party build system can be generated using `GenerateProjectFiles.bat` or `GenerateProjectFiles.sh`.
For the rest of this section, `GenerateProjectFiles` means either the `.bat` version or the `.sh` version depending on which platform you're on.
Both are located in the root Unreal Engine directory.
Pass the path to the `.uproject` file, an optional list of project file formats, and optionally the `-Game`/`-Engine` flags:
`./GenerateProjectFiles <PATH>/<PROJECT>.uproject -CMakefile -QMakefile -Makefile -Game`
This gives the IDE knowledge of the project structure and provides a simplified build interface for the user.
Rerun `GenerateProjectFiles` from time to time to keep the project files up to date with file system changes.  Especially after a `git pull` or `git merge`.
Rerun `GenerateProjectFiles` after making changes to the `.Build.cs` or `.Target.cs` files.
Do not make manual edits to the project files.
Do not make project changes from within an IDE.
Do not add the project files to source control.
The actual build process is independent of the project files and always locates build files and rules using the `.Build.cs` and `.Target.cs` files.
It is always safe to delete and regenerate the project files.
Sometimes necessary to fix build or configuration errors.

The type of project file to generate is set in one of:
- Parameter on the `GenerateProjectFiles` command line.  
    Such as `-CMakefile`, `-QMakefile`, or `-Makefile`.
    Mulitple types are supported.
- In `~/.config/Unreal\ Engine/UnrealBuildTool/BuildConfiguration.xml`
    Using the `<Format>` tag inside the `<ProjectFileGenerator>` tag.
    Here the formats are named `CMake`, `QMake`, and `Make`.
    Multiple types are not supported, despite the documentation calling it a "list".

Optinal parameters that are neither required nor recommended:
- `-CurrentPlatform`: Genearete project files for the platform you are running on only, i.e., not console or mobile.
- `-ThirdParty`: Include third-party libraries in the project. Will increase load on the IDE.
- `-Game <GAME_NAME>`: Only include the project's xosw, not the engine or other discovered projects. Must specify a project name.  
    I don't understand this one. What is the `<GAME_NAME>` I should pass? What isn't the `.uproject` file enough? The example in the documentation doesn't pass a `<GAME_NAME>`.
- `-Engine`: Include the engine code to be included in the project files. Should be used together with `-Game`.  
    Also confusing. What is the difference between passing nothing and passing both `-Game` and `-Engine`? What is the semantics of passing neither `-Game` nor `-Engine`?
- `OnlyPublic`: Only include public header files for the engine modules. Reduces the load of the IDE.  
    Is this useful only with `-Engine`? How about also with neither `-Game` nor `-Engine`? Is the engine headers included even if used with `-Game` without `-Engine`?

The `GenerateProjectFiles`script  can be run from any directory, the build files will be stored in the project directory regardless.
It will behave as-if run from the Unreal Engine root directory.
The script will analyze the `.Build.cs` and `.Target.cs` files and generate corresponding project files.
The script is a wrapper around Unreal Build Tool, invoking it with the `-ProjectFiles` command-line option.
The hand-over line is
`mono "$BASE_PATH/../../../Binaries/DotNET/UnrealBuildTool.exe" -projectfiles "$@"`
The Unreal Engine packaged version of `mono` is made available with `source "$BASE_PATH/SetupMono.sh" "$BASE_PATH"`.
`BASE_PATH` is `<UE_ROOT>/Engine/Build/BatchFiles/Linux`.

[UnrealBuildTool@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/index.html)  
[BuildConfiguration@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/BuildConfiguration/index.html)
[ProjectFilesForIDEs@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/ProjectFilesForIDEs/index.html)


## Targets

I don't understand targets vs modules. Is there a 1:1 relationship? Does not seem like it.
How does each target know which modules it should build?

Targets form the entry points into the build system. When we build a project we always build one of the targets.
A target include a number of modules. I don't know how this list of modules is produced.

A target is delcared in a `<TARGET>.Target.cs` file stored in the `Source` directory of the project.
Defines how the target is built.
Contains a class named `<TARGET>Target`.
`<TARGET>` is often a project, so the file would be named, for example, `MyProject.Target.cs` and the class inside `MyProjectTarget`.
The class' constructor set properties for the target, such as the target's type.
An example `MyProject.Target.cs` file:
```csharp
using UnrealBuildTool;
using System.Collections.Generic;
public class MyProjectTarget : TargetRules
{
    public MyProjectTarget(TargetInfo Target) : base(Target)
    {
        Type = TargetType.Game;
        // Other properties go here
    }
}
```

There are different types of targets:
- **Game**  
    A standalone game which requires cooked data to run.
- **Client**  
    Same as Game, but does not include any server code. Useful for networked games.
- **Server** 
    Same as Game, but does not include any client code. Useful for dedicated servers in networked games.
- **Editor**  
    A target which extends the Unreal Editor.
- **Program**  
    A standalone utility program built on top of the Unreal Engine.

Has a setting named `ExtraModuleNames`.
What makes a module `extra`? Which modules are not `extra`?
Are some modules automatically included in the Target? Is so, which modules?

[TargetFiles@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/TargetFiles/index.html)


## Build configuration

Build configuration options can be configured on a per-project or global basis using `BuildConfiguration.xml` config files.
For per-project settings put the file in the `Config/UnrealBuildTool/` directory in the project root.
For global settings put the file in:
- Linux: `~/.config/Unreal\ Engine/UnrealBuildTool/BuildConfiguration.xml`
- macOS: `/Users/<USER>/Unreal Engine/UnrealBuildTool/BuildConfiguration.xml`
- Windows: `**My Documents**/Unreal Engine/UnrealBuildTool/BuildConfiguration.xml`

The settings are grouped into categories. The XML document structure should match those categories.
For example:
```xml
<?xml version="1.0" encoding="utf-8" ?>
<Configuration xmlns="https://www.unrealengine.com/BuildConfiguration">
    <BuildConfiguration>
        <bEnableAddressSanitizer>true</bEnableAddressSanitizer>
        <bEnableThreadSanitizer>true</bEnableThreadSanitizer>
    </BuildConfiguration>
    <ProjectFileGenerator>
        <Format>CMake</Format>
    </ProjectFileGenerator>
    <LocalExecutor>
		<ProcessorCountMultiplier>2</ProcessorCountMultiplier>
	</LocalExecutor>
	<ParallelExecutor>
		<ProcessorCountMultiplier>2</ProcessorCountMultiplier>
	</ParallelExecutor>
</Configuration>
```

[BuildConfiguration@https://docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/BuildConfiguration/index.html)


## Include what you use

Also called IWYU, for short.
Avoid including monolithing header files such as `Engine.h` or `UnrealEd.h`.
Every file should inlucde only what it needs.
There are four conventions:
- All header files include their required dependencies.
- `.cpp` files include their matching `*.h` files first.
- PCH files are no longer explicitly included.
- Monolithic header files are no longer included.

The build system will warn on violations of the include-own-header-first and no-monolithic-headers rules.
To disable these warnings set `bEnforceIWYU` to `false`.

Enable IWYU by setting `bEnforceIWYU` to `true` and `PCHUsage` to `UseExplicitOrSharedPCHs` in the `ModuleRules` subclass' constructor in the module's `.Build.cs` file.
```csharp
public class MyProject : ModuleRules
{
    public MyProject(TargetInfo Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
        bEnforceIWYU = true;
    }
}
```
An explicit precompiled header file is created for the module only if it has the `PrivatePCHHeaderFile` setting also set.
Otherwise, the module may share precompiled header file with other modules.
To opt-out of IWYU set `PCHUsage` to `UseSharedPCHs`.

I don't understand the relationship between `Explicit` and `Shared` precompiled headers.
`UseExplicitOrSharedPCHs` sounds like an either/or where either `Explicit` or `Shared` is used
`Explicit` is used if `PrivatePCHHeaderFile` is set.
When `PrivatePCHHeaderFile` is not set, then it seems it should chose `Shared`.
But we disable IWYU by setting `PCHUsage` to `UseSharedPCHs`.
Is the `PrimatePCHHeaderFile` set to something by default and IWYU enabled in that case, or is the shared half of `UseExplicitOrSharedPCHs` different from `UseSharedPCHs`?
Does the shared half of `UseExplicitOrSharedPCHs` mean "the Unreal Build Tool may share however it likes" and "UseSharedPCHs" mean that there is a fixed set of shared precompiled headers, such as `Engine.h` and `UnrealEd.h`, that can be used?

IWYU makes precompiled headers less obtrusive and automatically handled by the Unreal Build Tool behind the scenes.

Some tips:
- Include `CoreMinimal.h` at the top of each header file. Why?
- Build the project in non-unity mode with PCH files disabled from time to time.  
    To ensure that every files get the includes they need.
- Use `UEngine` and `GEngine` through `Engine/Engine.h` and not `Engine.h`.
- The documentation page for each class show which header file you need to include to use it.
- If you have a legacy C++ project, use the IncludeTool.  
    It converts legacy C++ projects into IWYU-style projects.

[IWYU@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/IWYU/index.html)


## The build process

Has two steps:
- Unreal Header Tool parses the header files to extract type metadata then generates code to implement requested features.
- The normal C++ compiler is invoked to compile the results.


## Build graph

Script-based built automation system.
Graph of building blocks.
Examples of building blocks: compile, cook, run test.
Extensible and customizable.
Integrates with UnrealBuildTool, AutomationTool, and Unreal Editor.
Build graphs are run with `RunAUT`, which is at `<UE4Root>/Engine/Build/BatchFiles/RunUAT.(sh)|(bat).`

The name of the graph is passed with the `-Scripts=` parameters.
The path is relative to the root Unreal Engine directory.
Arguments to the particular script are passed after the script name (I think, it could be that `-ListOnly` is a global option that they just happened to place last.).

`RunUAT BuildGraph -Script=Engine/Build/Graph/Examples/AllExamples.xml -ListOnly`

Options (see below) are set with `-Set:<PROPERTY>=<VALUE>`.

List nodes to be executed for a target: `RunUAT BuildGraph -Script=EngineBuild/Graph/Examples/AllExamples.xml -Target="<TARGET>" -ListOnly`

Old builds are cleaned with `-Clean` at the end.

Putput debug graph: `RunUAT BuildGraph -Script="<SCRIPT>" -Target="<TARGET>" -Preprocess="<PATH>.xml"`


Graphs written in XML.
Encodes graph of nodes and dependnecies.
A node contains a list of tasks to execute.
Built for build farm configuration.
Each node annotated with host machine requirements.
Tracks creation of output files.
Build artifacts transfered to and from a network share automatically.
Example graphs can be found at `<UE4Root>/Engine/Build/Graph/Examples`.
Script for binary distribution at `<UE4Root>/Engine/Build/InstalledEngineBuild.xml`.
Schema for the XML format at `<UE4Root>/Engine/Build/Grpah/Schema.xsd`.

Parts in a graph:
- Tasks: Actions that are executed as part of a build process.
- Nodes: A named sequence of rodered tasks. Nodes may have dependencies.
- Agents: A group of nodes executed on the same machine. No effect when building locally.
- Triggers: Container for groups that should only be executed after manual intervention.
- Aggregates: Groups of nodes and named outputs that can be referred to with a single name.

Values can be stored in `Property` elements.
Used for reusable or fonditially defined values.
Properties are referenced with `$(Property <NAME>)`.
Can be used within all attribute strings.
Values that are passed from the command line are declared with the `Option` element.
Environment variables are read with `EnvVar` elements.

Perforce style wildcards are used for file matching, i.e., `...`, `*`, `?` patterns.
Can define tagged collections of files.




### Creating build graphs





## Creating a binary release

There is a Build Graph script that creates an install version of Unreal Engine.
The script is `<UE4Root>/Engine/Build/InstalledBuild.xml`.
Run with
```
RunUAT BuildGraph -Target="Make Installed Build <PLATFORM>" -Script="Engine/Build/InstalledEngineBuild.xml" -Clean
```
Why the `-Clean` part?
Platform can be either `Win64`, `Mac`, or `Linux`.
The Installed Build is created at `<UE4Root>/LocalBuilds/Engine`.
Can be changed somehow, but the docs don't say how.

To build only for the host platform, pass `-Set:HostPlatformOnly=true`.
To disable Derived Data Cache build, pass `-Set:WithDDC=false`.
To select which configuration to build, pass `-Set:GameConfiguration=Development`.

Unreal Engine creates a BuildID for each build.
The BuildID prevents dynamic libraries from being used with the wrong build of the engine.
The purpose is to prevent stale and outdated dynamic libraries from being accidentally loaded, which is a common source of difficult-to-diagnose problems.
At build time a `.modules` JSON file is written to each output directory that has at least one compiled dynamic library.
This files lists the modules, their associated dynamic library, and the BuildID for the current build.
The `.modules` files should be included in binary releases of the engine.

[UsinganInstalledBuild@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/Deployment/UsinganInstalledBuild/index.html)  
[VersioningofBinaries@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/VersioningofBinaries/index.html)  


## Unorganized notes

From @Maliku 🐺 on Unreal Slackers:

> I'm currently building with "Engine/Build/BatchFiles/RunUAT.sh BuildGraph -target="Make Installed Build Linux" -script=Engine/Build/InstalledEngineBuild.xml -set:HostPlatformOnly=true -set:WithDDC=false -set:WithLinuxAArch64=false -set:HostPlatformDDCOnly=false -set:GameConfigurations=Development"

Read 
- https://docs.unrealengine.com/en-US/Programming/Deployment/UsinganInstalledBuild/index.html
- https://docs.unrealengine.com/en-US/Programming/BuildTools/AutomationTool/BuildGraph/index.html

