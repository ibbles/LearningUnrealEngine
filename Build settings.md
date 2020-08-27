2020-08-24_13:11:06

# Build settings

The build settings are specified in a `<module>.Build.cs` C# source file.


> Kinda confused on how to handle `Using backward-compatible build settings` error 
> What do I need to do to properly upgrade?

> In your all *Target.cs 's , add line  
> `DefaultBuildSettings = BuildSettingsVersion.V2;`