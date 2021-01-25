2020-08-24_13:11:06

# Build settings

The build settings for a module are specified in that module's `<module>.Build.cs` C# source file.

[[2020-09-10_19:55:50]] [Modules](./Modules.md)  

> Kinda confused on how to handle `Using backward-compatible build settings` error 
> What do I need to do to properly upgrade?

> In your all *Target.cs 's , add line  
> `DefaultBuildSettings = BuildSettingsVersion.V2;`



The amount of parallelization when building with Unreal Build Tool is set in an XML configuration file.
See [Build Configuration @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProductionPipelines/BuildTools/UnrealBuildTool/BuildConfiguration/index.html).

[[2020-03-09_21:57:41]] [Unreal Build Tool](./Unreal%20Build%20Tool.md)  

