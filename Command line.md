2020-09-28_07:47:55

# Command line

A collection of command line actions.

Initial build of Unreal Engine:
- `mkdir UnrealEngine_<VERSION>`
- `cd UnrealEngine_<VERSION>`
- `git clone https://github.com/EpicGames/UnrealEngine.git .`
- `git checkout <VERSION>-release`
- `./Setup.sh`
- `./GenerateProjectFiles.sh`
- `make`
- `./Engine/Binaries/Linux/UE4Editor`


Creating a binare release of Unreal Engine:
```
RunUAT.sh BuildGraph -Target="Make Installed Build Linux" -Script=Engine/Build/InstalledEngineBuild.xml -Set:HostPlatformOnly=true -Set:WithDDC=false -Set:WithLinuxAArch64=false -Set:HostPlatformDDCOnly=false -Set:GameConfigurations=Development -Clean
```
I think it's possible to pass multiple `GameConfigurations`. Shipping is good to have.


Generating build system project files for a C++ Unreal Engine project:
```
./GenerateProjectFiles.sh <PATH>/<PROJECT>.uproject -game -Makefile -CMakefile
```

Build a C++ Unreal Engine project:
```
make <ProjectName>Editor
```
```
make <ProjectName>
```
```
<UnrealRoot>/Engine/Build/BatchFiles/Linux/Build.sh <ProjectName> Linux Development -project=<UnrealProjectsDir>/<ProjectName>/<ProjectName>.uproject -game -progress -buildscw"`
```
```
<UnrealRoot>/Engine/Build/BatchFiles/Linux/Build.sh <ProjectName>Editor Linux Development -Project=<PATH TO UPROJECT>
```
```
# A source SetupMono.sh or similar is required here. Find the note and update here.
<UnrealRoot>/Engine/Binaries/DotNET/UnrealBuildTool.exe Development Linux -Project="projectpath.uproject" -TargetType=Editor -Progress -NoEngineChanges -NoHotReloadFromIDE
```

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