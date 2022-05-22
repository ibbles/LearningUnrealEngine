2021-10-01_16:04:08

## Installed Build

An engine Installed Build is an export of sorts from a source build to a distributable package that can be shared among developers on a team.

Epic Games provide Linux Docker images that can be downloaded to run Unreal Engine.
Use e.g. [Epic Asset Manager](https://github.com/AchetaGames/Epic-Asset-Manager) to download and unpack the Unreal Engine installation from the Docker image to the local machine.
The build scripts for the Docker images are available on GitHub: https://github.com/adamrehn/ue4-docker
On Linux the build command becomes
```shell
./Engine/Build/BatchFiles/RunUAT.sh
    BuildGraph
    -target="Make Installed Build Linux"
    -script=Engine/Build/InstalledEngineBuild.xml
    -set:WithDDC=false
    -set:HostPlatformOnly=true
```


Command I found somewhere:
```shell
.Engine/Build/BatchFiles/RunUAT.sh
    BuildGraph
    -Target="Make Installed Build Linux"
    -Script=Engine/Build/InstalledEngineBuild.xml
    -Set:WithDDC=false
    -Set:HostPlatformEditorOnly=true
    -Set:BuiltDirectory="/path/to/output/directory"
```
Not sure if the above is some official command line or something that someone just does.
The `BuiltDirectory` parameter was added in Unreal Engine 4.27.
When not set the output directory is set to `./LocalBuilds/Engine/`.
`Linux` will be appended to the `BuildDirectory`.

Below are some more variants.


For Linux:
```shell
./Engine/Build/BatchFiles/RunUAT.sh
    BuildGraph
    -Target="Make Installed Build Linux"
    -Script=Engine/Build/InstalledEngineBuild.xml
    -Set:WithDDC=false
    -Set:HostPlatformOnly=true
    # Additions:
    -Set:WithLinuxArm64=false # Pre UE5: -Set:WithLinuxAArch64=false
    -Set:GameConfigurations=Development
```

`GameConfigurations` is `DebugGame;Development;Shipping` by default.
Not sure what the valid values are.


For Windows (untested, just following the pattern):
```shell
RunUAT.bat BuildGraph
    -Target="Make Installed Build Win64"
    -Script=Engine/Build/InstalledEngineBuild.xml
    -Set:WithDDC=false
    -Set:HostPlatformOnly=true
    -Set:GameConfigurations=Development
```
The Installed Build is created at `<UE_ROOT>/LocalBuilds/Engine`.

The default setting doesn't include support for dedicated servers.
To add that, include `-set:WithClient=true -set:WithServer=true` in the command.

# Longer description

There is a Build Graph script that creates an install version of Unreal Engine.
The script is `<UE_ROOT>/Engine/Build/InstalledBuild.xml`.
Run with
```
RunUAT BuildGraph -Target="Make Installed Build <PLATFORM>" -Script="Engine/Build/InstalledEngineBuild.xml"
```

Platform can be either `Win64`, `Mac`, or `Linux`.
The Installed Build is created at `<UE_ROOT>/LocalBuilds/Engine`.
Can be changed with `-Set:BuildDirectory="/path.to/output/directory"` in Unreal Engine 4.27 and later.

To build only for the host platform, pass `-Set:HostPlatformOnly=true`.
To disable Derived Data Cache build, pass `-Set:WithDDC=false`.
To select which configuration to build, pass `-Set:GameConfiguration=Development`.
Multiple Game Configurations can be separated with `;`.

The above command will produce a build that is quite large, 100 GiB or so.
The below is supposed to produce a smaller build, but I haven't tested yet.
Is the `WithDDC=false` part the important bit?
I don't see why all the `With<PLATFORM>` bits are required when passing `HostPlatformEditorOnly=true`.
```
./Engine/Build/BatchFiles/RunUAT.sh BuildGraph
    -script=Engine/Build/InstalledEngineBuild.xml
    -target="Make Installed Build Linux"
    -nosign
    -set:HostPlatformEditorOnly=true
    -set:WithDDC=false
    -set:WithIOS=false
    -set:WithTVOS=false
    -set:WithMac=false
    -set:WithWin64=false
    -set:WithWin32=false
    -clean
```

Unreal Engine creates a Build ID for each build.
The Build ID prevents dynamic libraries from being used with the wrong build of the engine.
The purpose is to prevent stale and outdated dynamic libraries from being accidentally loaded, which is a common source of difficult-to-diagnose problems.
At build time a `.modules` JSON file is written to each output directory that has at least one compiled dynamic library.
This files lists the modules, their associated dynamic library, and the Build ID for the current build.
The `.modules` files should be included in binary releases of the engine.

## Null Source Code Accessor

Unreal Engine 4.25 had a bug on Linux where new C++ projects couldn't be created and projects not packaged unless the Clang system package was installed.
See [[2021-07-09_09:02:27]] [Source code accessor](./Source%20code%20accessor.md).

[UsinganInstalledBuild@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/Deployment/UsinganInstalledBuild/index.html)  
[VersioningofBinaries@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/VersioningofBinaries/index.html)  


Read 
- https://docs.unrealengine.com/en-US/Programming/Deployment/UsinganInstalledBuild/index.html

[[2021-07-09_09:54:02]] [Build ID](./Build%20ID.md)  
[[2020-08-22_22:55:03]] [Building and installing Unreal Engine from source](./Building%20and%20installing%20Unreal%20Engine%20from source.md)  
[[2020-09-28_07:47:55]] [Command line](./Command%20line.md)  
