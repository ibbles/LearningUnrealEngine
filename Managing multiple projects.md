2020-12-15_16:04:11

# Managing multiple projects

There is something called Unreal Game Sync.
It is designed for large teams.

Ways to distribute a build:
- Check in binaries to source control.
    Drawbacks: large file sizes, upgrading the engine is a long process, easy to commit a broken build which breaks everyone.
- Unreal Game Sync.
    Drawbacks: Considerable investment in backed resources.
- Custom installed builds.
    Drawbacks: Difficult to support modified engines, unless the same modifications are applicable to all projects.

`Custom Install Build`: A locally, i.e., not by Epic Games, pre-compiled version of Unreal Engine.  
`Source Drop`: A copy of Unreal Engine.  Either an engine drop (source code) or a development drop (compiled binaries).  
`Engine Drop`: The source code for Unreal Engine, including local modifications.
`Development Drop`: A Custom Install Build of the engine drop.
`Project`: An Unreal Engine project. Does not include the engine itself, only the projects assets and sources.

There can be multiple development drops and projects, but only one engine drop.
Engine developers have read-write access to engine drop.
Engine builders have read-only access to the engine drop and read-write access to development drop.
Project developers have read-only access to the development drop and read-write access to their projects.
Each project is tied to a particular development drop.

A custom install build will include the plugins that have been installed to the engine, e.g., from the Marketplace.

Unreal Automation Tool is a tool used to automate various tasks.
It is controlled/programmed using scripts which defines each task.
One predefined task is Build Graph.
There are many build graphs, one is Installed Engine Build.
Install Engine Build contains a number of Nodes.
Each node represents an action, such as `Make Installed Build Win64`.
A node name should be provided, using the `-TARGET=` parameter, when executing a Build Graph.
Install Engine Build contains a number of Options.
Options are set using `-set:[option]=<value>` when executing a Build Graph.
Read `InstallEngineBuild.xml` for more information on the options.
A lot of options can be turned off, especially all the hardware and platform support you don't need.
A Build Graph is launched with `RunUAT`.
```
RunUAT BuildGraph -Target="Maked Installed Buid Win64" -Script=Engine/Build/InstalledEngineBuild.xml
```

Unreal Engine uses Unreal Version Selector to launch projects with the correct Unreal Engine version.
It reads the Engine Association property from the Unreal Project File that is being opened.
On Windows it uses the registry to map an engine version to an installation directory.
Don't know how it works on Linux.
For official builds Epic Games set an Engine Association ID for each engine version.
For Custom Install Builds a random GUID is generated but it can be replaced with any string you like. (where?)

A Custom Install Build doesn't include everything you need.
The page lists `UnrealVersionSelector`, `Setup.bat`, and `GITDependencies` as missing.
After copying a Custom Install Build to a new machine, run `Setup.bat`.



[Managing Multiple UE4 Projects @ wiseengineering.com](https://wisengineering.com/downloads/ManagingUE4Projects.pdf)   
[UnrealGameSync (UGS) @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProductionPipelines/DeployingTheEngine/UnrealGameSync/index.html)  
