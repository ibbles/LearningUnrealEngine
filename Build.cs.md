2020-09-18_08:51:49

# Build.cs

A `Build.cs` file is a C# class that defines how a module should be built.
In the `Build.cs` file a subclass of `ModuleRules` is defined.
In the class' constructor we define, for example:
- The module's type.
- Compiler definitions/macros.
- Compiler include paths.
- Linker library search paths.
- Additional library dependencies.

Most of these settings can be either public or private.
Public means that any module that depend on this module also get the settings.
Private means that only the current module get the settings.
I don't think that `Build.cs`/`ModuleRules` has anything like CMake's `INTERFACE`.

The `Build.cs` file has sligthly different semantics for third-party libraries.

[[20200827122445]] [Third-pary libraries](./Third-pary%20libraries.md)  
[[Modules]] [Modules](./Modules.md)  
[[Module types]] [Module types](./Module%20types.md)  
[[ModuleType]] [ModuleType](./ModuleType.md)  
