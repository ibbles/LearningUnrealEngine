2020-09-10_19:55:50

# Modules

A module is a collection of C++ files that are compiled together with the same compiler flags.
One or more modules are linked together as part of a Target into a dynamically linked library.
The C++ files are stored in a directory for the module along with a `<ModuleName>.Build.cs` file.
The `Build.cs` file describe how the module is to be compiled.

The engine is built up from a large collection of modules.
Projects and plugins can also contain modules.

A module is declared in the owning project's or plugin's `.upoject` or `.uplugin` file.
The `Modules` attribute is an array that contains `Module` elements.
A `Module` element contains at least `Name`, `Type`, and `LoadingPhase`.
`Name` can be any string.
`Type` is one of `Runtime`, `Developer(Tool?)`, or `Editor`. There are a few more.
`LoadingPhase` is one of `Default`, ...?
Can also have `WhitelistPlatforms` and `BlacklistPlatforms`.
```
{
	"Name": "MyModule",
	"Type": "Editor",
	"LoadingPhase": "PostEngineInit"
},
```

[[2020-09-15_21:10:32]] [Module types](./Module%20types.md)  

A module consists of a private part and public part.
The private part can only be used by the module itself.
The public part can be used by other modules as well.
The public part is a collection of header files.
The public part can contain both header and source files.
A module using functionality provided by another module is called a dependency.
The public part is stored in the `<ModuleName>/Public` directory.
The private part is stored in the `<ModuleName>/Private` directory.
For simple modules this is exactly the `.h`/`.cpp` separation.
But modules may place source files differently.

Classes defined within a module's public header files should be decorated with the module's `*_API` macro.
This exports the class from the module so that it can be used by other modules.
For example: `class MYMODULE_API UMyClass : public UObject`.
The definition for the macro is automatically created by the engine.

Example module file system organization, for a module named `MyModule`:
```
MyModule
├── MyModule.Build.cs
├── Private
│   └── MyModule.cpp
└── Public
    └── MyModule.h
```

Each module must have exactly one `*.Build.cs` file.
It should contain a C# class that define how the module is to be compiled.
At build time Unreal Build Tool searches the project directory tree for `*.Build.cs` files.

[[2020-09-18_08:51:49]] [Build.cs](./Build.cs.md)  

Each module must have exactly one `<MODULE_NAME>.(cpp|h)` file.
This is where the module itself is declared for the C++ runtime.
Contains a single class (usually) that implements `IModuleInterface`.
Has two virtual methods:
- `StartupModule`
    Called when the editor or game is starting, really when the module is loaded into memory. Do initialization here.
- `ShutdownModule`
    Called when the editor or game is shutting down, really when the module is unloaded from memory.
    
`MyModule.h`:    
```cpp
#pragma once

#include "CoreMinimal.h"
#include "Modules/ModuleInterface.h"
#include "Modules/ModuleManager.h"

class FMyModule : public IModuleInterface
{
public:
	virtual void StartupModule() override;
	virtual void ShutdownModule() override;
};
```

`MyModule.cpp`:
```cpp
#include "MyModule.h"

#include "Modules/ModuleManager.h"
#include "Modules/ModuleInterface.h"

IMPLEMENT_GAME_MODULE(FMyModule, MyModule);

#define LOCTEXT_NAMESPACE "FMyModule"

void FMyModule::StartupModule()
{
}

void FMyModule::ShutdownModule()
{
}

#undef LOCTEXT_NAMESPACE
```

[[2020-09-10_19:42:18]] [Code projects](./Code%20projects.md)  
[[2020-09-15_17:27:33]] [Plugins](./Plugins.md)  
[[2020-09-15_21:10:32]] [Module types](./Module%20types.md)  
[[2020-09-18_08:51:49]] [Build.cs](./Build.cs.md)  
[[2021-02-19_21:30:15]] [Modules Build.cs and Target.cs](./Modules%20Build.cs%20and%20Target.cs.md)  
[[2021-02-19_18:50:48]] [Creating a new module](./Creating%20a%20new%20module.md)  


