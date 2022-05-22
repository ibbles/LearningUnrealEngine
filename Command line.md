2020-09-28_07:47:55

# Command line

A collection of command line actions.
These are printed with newlines between each parameter to make them easier to read.

## Engine stuff

### Initial build of the engine

Initial build of Unreal Engine:
- `mkdir UnrealEngine_<VERSION>`
- `cd UnrealEngine_<VERSION>`
- `git clone https://github.com/EpicGames/UnrealEngine.git .`
- `git checkout <VERSION>-release`
- `./Setup.sh`
- `./GenerateProjectFiles.sh`
- `make`
- `./Engine/Binaries/Linux/UE4Editor`

### Creating a binary release of the engine

[[2020-08-22_22:55:03]] [Building and installing Unreal Engine from source](./Building%20and%20installing%20Unreal%20Engine%20from%20source.md)  
[[2021-10-01_16:04:08]] [Installed Build](./Installed20Build.md)  

Creating a binary release of Unreal Engine:
```
./Engine/Build/BatchFiles/RunUAT.sh
    BuildGraph
    -Target="Make Installed Build Linux"
    -Script=Engine/Build/InstalledEngineBuild.xml
    -Set:HostPlatformOnly=true
    -Set:WithDDC=false
    -Set:WithLinuxAArch64=false
    -Set:HostPlatformDDCOnly=false
    -Set:GameConfigurations="Development;Shipping"
    -Clean
```
Multiple `GameConfigurations` can be passed, separated by `';'`.
I know of Shipping and Development.
There is probably Debug as well.
This flag is for what you are doing with the engine itself.
If you are working on a project, and not the engine, then use Shipping.
I think one can build projects in Development using a Shipping engine.
Both Development and Shipping is required to export plugins with `RunUAT BuildPlugin`.
See `BuildPluginCommand.Automation.cs` in the engine source, an excerpt:
```cpp
CompilePluginWithUBT(
    HostProjectFile, HostProjectPluginFile, Plugin, "UE4Game", TargetType.Game,
    TargetPlatform, UnrealTargetConfiguration.Development, // Hard coded development.
    ManifestFileNames, AdditionalTargetArgs);

CompilePluginWithUBT(
    HostProjectFile, HostProjectPluginFile, Plugin, "UE4Game", TargetType.Game,
    TargetPlatform, UnrealTargetConfiguration.Shipping,  // Hard-coded shipping.
    ManifestFileNames, AdditionalTargetArgs);
```


### Benchmarks

`%UAT_PATH% BenchmarkBuild -project=UE4 -editor -client -noxge -iterations=1`

## Project stuff

### Generate C++ project files

Generating build system project files for a C++ Unreal Engine project using wrapper script:
```
$UE_ROOT/GenerateProjectFiles.sh
    <PATH>/<PROJECT>.uproject
    -Game
    -Makefile
    -CMakefile
```

This will generate a `CMakeLists.txt` that can be used to open the project in any C++ IDE that supports CMake projects.
A bunch of settings, such as include paths, are stored in `<PROJECT>/Intermediate/ProjectFiles/`.
When using an Installed Build of the engine a massive number of include paths are listed.
So many that  CLion errors out with 
```
g++: fatal error: cannot execute '/usr/lib/gcc/x86_64-linux-gnu/9/cc1plus': execv: Argument list too long
```
while parsing the project.
I "fixed" it by deleting a bunch of stuff from the end of the list  in `<PROJECT>/Intermediate/ProjectFiles/cmake-includes.cmake`.
I found what could be deleted by generating parallel project using a source build of the engine and comparing the two files.

Generating build system project files for a C++ Unreal Engine project using `Build.sh`:
```
$UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh
    ProjectFiles
    -Project=<PATH>/<PROJECT>.uproject
    -Game
    -Makefile
```



### Building a C++ project

Build a C++ Unreal Engine project with the generated project files. Here assuming `Makefile`:
```
make <ProjectName>Editor
```
The above builds for use in the editor.
The below builds for use in an cooked/exported project. (Is this really true? I don't think this does a full cook.)
```
make <ProjectName>
```

To clean the build files, i.e., prepare for a full rebuild, pass `ARGS="-clean"` to `make`.
```
make <ProjectName>Editor ARGS="-clean"
```

** We may want `-NoEngineChanges` on a bunch of these, to avoid editing stuff in the engine installation.
EXPERIMENTATION NEEDED.

Build a project with `Build.sh`:
```
$UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh
    <PROJECT>
    Linux
    Development
    -Project=<PATH>/<PROJECT>.uproject
    -Game
    -Progress
    -buildscw"`
```
Not sure what the `-buildscw` part does. Possibly related to Shader Compiler Workers. Not sure why it's on the `<PROJECT>` build but not the `<PROJECT>Editor` build.

Build the Editor target for a project:
```
$UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh
    <PROJECT>Editor
    Linux
    Development
    -Project=<PATH>/<PROJECT>.uproject
```

The recommended (on the [Unreal Slackers](https://discord.com/channels/187217643009212416/375022233875382274) Discord Linux channel) way to build a project to fix the `module missing or incompatible` error at Unreal Editor startup:
```
$UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh
    Linux
    Development
    -Project=<PROJECT_PATH>/<PROJECT>.uproject
    -TargetType=Editor
```
This replaces the old recommendation, which was `BatchFiles/Linux/Build.sh <PROJECTNAME>Editor Linux` but that doesn't work for Blueprint-only projects.

If the command above builds nothing and you still get `LogInit: Warning: Incompatible or missing module` then run the same command again but with `-Clean` appended at the end. **WARNING** This will rebuild a whole chunk of the engine and take a long time. 

Building with Unreal Build Tool directly:
```
# A source SetupMono.sh or similar is required here. Find the note and update here.
$UE_ROOT/Engine/Binaries/DotNET/UnrealBuildTool.exe Development Linux -Project="<PATH>/<PROJECT>.uproject" -TargetType=Editor -Progress -NoEngineChanges -NoHotReloadFromIDE
```
Don't know what other options for `TargetType` might be.

### Packaging a project

On Linux, clicking Package Project in Unreal Editor runs the following Unreal Automation Tool command:
```
mono AutomationTool.exe
    -ScriptsForProject=<PROJECT_PATH>/<PROJECT_NAME>.uproject 
    BuildCookRun
    -nocompileeditor
    -nop4
    -project=<PROJECT_PATH>/<PROJECT_NAME>.uproject
    -cook
    -stage
    -archive
    -archivedirectory=<PACKAGE_PATH>/
    -package
    -ue4exe=$UE4_ROOT/Engine/Binaries/Linux/UE4Editor
    -pak
    -prereqs
    -nodebuginfo
    -targetplatform=Linux
    -build
    -target=MyProject
    -clientconfig=Development
    -utf8output
```

I expect there to be a fairly straightforward conversion to a `RunUAT.sh` command line from this.

Maybe like this?
```bash
$UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh
    BuildCookRun
    -project=$PROJECT_ROOT/$PROJECT_NAME.uproject
    -stage
    -package
    -build
    -cook
    -pak
    -compressed
```

An example RunUAT line to build a server:
```
RunUAT
    BuildCookRun
    -project="MyProject".uproject
    -noP4
    -platform=Linux
    -clientconfig=Development
    -serverconfig=Development
    -cook
    -server
    -serverplatform=Linux
    -targetplatform=Linux
    -noclient
    -build
    -compile
    -stage
    -pak
    -archive
    -archivedirectory="MyProjectOutputDir"
```

Cross compiling a Linux server from Windows:
```cpp
RunUAT.bat
    BuildCookRun
    -project="MyProj\MyProj.uproject"
    -noP4
    -platform=Win64
    -allmaps
    -build
    -noclient
    -server
    -ServerConfig=Development
    -ServerPlatform=Linux
    -cook
    -pak
    -stage
    -CrashReporter
```

Another variant, not sure what it does:
```
RunUAT.bat BuildCookRun -project="Path/To/Project.uproject" -clientConfig=Shipping -installed -noP4 -platform=Win64 -cook -build -allmaps -stage -pak -archive
```

Another variant I copied from somewhere. Maybe the same:
```
$UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh
    -ScriptsForProject=$MY_PROJECT/$MY_PROJECT.uproject
    BuildCookRun
    -project=$MY_PROJECT/$MY_PROJECT.uproject
    -noP4
    -clientconfig=Development
    -utf8output
    -platform=Linux
    -targetplatform=Linux
    -cook
    -allmaps
    -compressed
    -archive
    -unversionedcookedcontent
    -archivedirectory="$TARGET_DIRECTORY/$MY_PROJECT"
```

One can set Project Settings > Cooker > Cooker Progress Display Mode to get more or less information from the cooker.

This builds something, not sure what. From https://discord.com/channels/187217643009212416/375022233875382274/935265408053809224
```
$UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh
    -ScriptsForProject=$PROJECT_ROOT/$PROJECT_NAME.uproject
    BuildCookRun
    -project=$PROJECT_ROOT/$PROJECT_NAME.uproject
    -noP4
    -clientconfig=$([[ "$CI_COMMIT_BRANCH" == "master" ]] && echo "Shipping" || echo "Development")
    -serverconfig=$([[ "$CI_COMMIT_BRANCH" == "master" ]] && echo "Shipping" || echo "Development")
    -nocompileeditor
    -ue4exe=$UE_ROOT/Engine/Binaries/Linux/UE4Editor
    -utf8output
    -platform=Linux
    -server
    -serverplatform=Linux
    -targetplatform=Linux
    -build
    -cook
    -allmaps
    -unversionedcookedcontent
    -createreleaseversion=
    -basedonreleaseversion=1.0.0
    -compressed
    -prereqs
    -stage
    -package
    -stagingdirectory=$BUILD_ROOT/staging/$PROJECT_NAME
    -archive
    -archivedirectory=$BUILD_ROOT/builds/$PROJECT_NAME
```

### Compiling shaders (I think)

```
UE4Editor "path to uproject" -run=DerivedDataCache -fill -projectonly
```


### Compiling Blueprints

```
$UE_ROOT/Engine/Binaries/Linux/UE4Editor-Cmd
    $MY_PROJECT/$MY_PROJECT.uproject
    -run=CompileAllBlueprints
    -VeryVerbose
```

This is useful for debugging cooking crashes since it's one of the steps that the cooking process takes.

## Plugin stuff

### Exporting a plugin
```
eval $UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh BuildPlugin -Plugin=<PATH>/<PROJECT>/Plugins/<PLUGIN>/<PLUGIN>.uplugin -Package=<PATH>/<OTHER_PROJECT>/Plugins/<PLUGIN> -Rocket
```
Don't know what `-Rocket` does.
May want to add a `-TargetPlatform(s?)=` here.

## Other stuff

Unpack a `.pak` file:
```
unrealpak.exe "path/to/pak" -extract "path/to/empty/folder"
```

Building a third-party CMake library.
The following is from the [Unreal Engine 4.25 release notes](https://docs.unrealengine.com/en-US/Support/Builds/ReleaseNotes/4_25/index.html):
```
RunUAT.bat BuildCMakeLib -TargetLib=ExampleLib -TargetLibVersion=examplelib-0.1 -TargetConfigs=relase+debug -TargetPlatform=PlatformName -LibOutputPath=lib -CMakeGenerator=Makefile -CMakeAdditionalArguments="-DEXAMPLE_CMAKE_DEFINE=1" -MakeTarget=all -SkipSubmit
```

[[20200827122445]] [Third-party libraries](./Third-party%20libraries.md)  