2020-09-18_08:51:49

# Build.cs

A `Build.cs` file is a C# class that defines how a module should be built.
In the `Build.cs` file a subclass of `ModuleRules` is defined.
In the class' constructor we define a number of properties, for example:
- The module's type.
- Compiler definitions/macros.
- Compiler include paths.
- Linker library search paths.
- Additional library dependencies.
- `<Visibility>DependencyModuleNames`
    Modules this module wishes to import/use. This is how `public` build properties of other modules are inherited into this module.
    `PublicModuleNames` is propagated to modules that depend on this module.
    `PrivateModuleNames` are included only when building this module.
- `<Visibility>IncludePaths`
  Directories that the compiler should look for header files in.
  `PublicIncludePaths` should only contain directories within the module's `Public` subdirectory.
  `PrivateIncludePaths` should only contain directories within the module's `Private` subdirectory.
    For `PrivateIncludePaths` the given paths are relative to the module's `Private` directory. Directories in the `Public` subdirectory are found and added automatically by Unreal Build Tool, so no need to list them.

Most of these settings can have either public or private visbility.
Public means that any module that depend on this module also get the setting.
Private means that the dependency is only for the module's private implementation, is only used when compiling the module itself.
Private means that only the current module get the settings.
I don't think that `Build.cs`/`ModuleRules` has anything like CMake's `INTERFACE`.

Example `Build.cs` file:
```
TODO: Paste some code into here.
```


The `Build.cs` file has slightly different semantics for modules that represetnt third-party libraries.
Third-party library modules are not compiled by Unreal Buid Tool, but they can provide compiler settings that are inherited by other modules that depend on the third-party library module.

We  can detect monolithic builds and add preprocessor definitions  based on that:
```csharp
if (Target.LinkType != TargetLinkType.Monolithic)
{
    PrivateDefinitions.Add("MyFlag=1");
}
```

[[2020-08-27_12:24:45]] [Third-party libraries](./Third-party%20libraries.md)  
[[2020-09-10_19:55:50]] [Modules](./Modules.md)  
[[2020-09-15_21:10:32]] [Module types](./Module%20types.md)  
[[2020-09-11_12:52:42]] [ModuleType](./ModuleType.md)  
