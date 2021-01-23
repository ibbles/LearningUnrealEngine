2020-09-10_19:55:50

# Modules

A module is a collection of C++ files that are compiled and linked together into a library.
The C++ files are stored in a directory for the module along with a `<ModuleName>.Build.cs`.
The `Build.cs` file describe how the module is to be compiled.

The engine is built up from a large collection of modules.
Projects and plugins can also contain modules.

A module is declared in the owning project's or plugin's `.upoject` or `.uplugin` file.
The `Modules` attribute is an array that contains `Module` elements.
A `Module` element contains at least `Name`, `Type`, and `LoadingPhase`.
`Name` can be anything.
`Type` is one of `Runtime`, `Developer(Tool?)`, or `Editor`. There are a few more.
`LoadingPhase` is one of `Default`, ...?
Can also have `WhitelistPlatforms` and `BlacklistPlatforms`.
```
TODO: Add example module entry here.
```

[[2020-09-15_21:10:32]] [Module types](./Module%20types.md)  

A module consists of a private part and public part.
The private part can only be used by the module itself.
The public part can be used by other modules as well.
A module using functionality provided by another module is called a dependency.
The public part is stored in the `<ModuleName>/Public` directory.
The private part is stored in the `<ModuleName>/Private` directory.
For simple modules this is exactly the `.h`/`.cpp` separation.
But modules may place source files differently.

Classes defined within a module should be decorated with the module's `*_API` macro.
This exports the class from the module so that it can be used by other modules.
For example: `class MYMODULE_API UMyClass : public UObject`.
The definition for the macro is automatically created by the engine.

Example module file system organization, for a module named `MyFirstModule`:
```
MyFirstModule
├── MyFirstModule.Build.cs
├── Private
│   └── MyFirstModule.cpp
└── Public
    └── MyFirstModule.h
```

Each module must have exactly one `*.Build.cs` file.
It should contain a C# class that define how the module is to be compiled.
At build time Unreal Build Tool searching the project directory tree for `*.Build.cs` files.

[[Build.cs]] [Build.cs](./Build.cs.md)  

Each module must have exactly one `*Module.cpp` file.
This is where the module itself is declared for the C++ runtime.
Contains a single class (usually) that implements `IModuleInterface`.
Has two virtual methods:
- `StartupModule`
    Called when the editor or game is starting, really when the module is loaded into memory. Do initialization here.
- `ShutdownModule`
    Called when the editor or game is shutting down, really when the module is unloaded from memory.

[[2020-09-10_19:42:18]] [Code projects](./Code%20projects.md)  
[[2020-09-15_17:27:33]] [Plugins](./Plugins.md)  
[[2020-09-15_21:10:32]] [Module types](./Module%20types.md)  
[[2020-09-18_08:51:49]] [Build.cs](./Build.cs.md)  