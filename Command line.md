2020-09-28_07:47:55

# Command line

A collection of command line actions.

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

Creating a binare release of Unreal Engine:
```
RunUAT.sh BuildGraph -Target="Make Installed Build Linux" -Script=Engine/Build/InstalledEngineBuild.xml -Set:HostPlatformOnly=true -Set:WithDDC=false -Set:WithLinuxAArch64=false -Set:HostPlatformDDCOnly=false -Set:GameConfigurations=Development;Shipping -Clean
```
I think it's possible to pass multiple `GameConfigurations`. Shipping is good to have because the `BuildPlugin` `RunUAT` command require it.

### Benchmarks

`%UAT_PATH% BenchmarkBuild -project=UE4 -editor -client -noxge -iterations=1`

## Project stuff

### Generate C++ project files

Generating build system project files for a C++ Unreal Engine project using wrapper script:
```
eval $UE_ROOT/GenerateProjectFiles.sh <PATH>/<PROJECT>.uproject -Game -Makefile -CMakefile
```

Generating build system project files for a C++ Unreal Engine project using `Build.sh`:
```
eval $UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh ProjectFiles -Project=<PATH>/<PROJECT>.uproject -Game -Makefile
```

### Building a C++ project

Build a C++ Unreal Engine project with the generated project files. Here assuming `Makefile`:
```
make <ProjectName>Editor
```
The above builds for use in the editor.
The below builds for use in an cooked/exported project.
```
make <ProjectName>
```

Build a project with `Build.sh`:
```
eval $UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh <PROJECT> Linux Development -project=<PATH>/<PROJECT>.uproject -Game -Progress -buildscw"`
```
```
eval $UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh <PROJECT>Editor Linux Development -Project=<PATH>/<PROJECT>.uproject
```

Not sure what the `-buildscw` part does. Possibly related to Shader Compiler Workers. Not sure why it's on the `<PROJECT>` build but not the `<PROJECT>Editor` build.

Building with Unreal Build Tool directory.
```
# A source SetupMono.sh or similar is required here. Find the note and update here.
$UE_ROOT/Engine/Binaries/DotNET/UnrealBuildTool.exe Development Linux -Project="<PATH>/<PROJECT>.uproject" -TargetType=Editor -Progress -NoEngineChanges -NoHotReloadFromIDE
```
Don't know what other options for `TargetType` might be.


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

[[20200827122445]] Third-party libraries