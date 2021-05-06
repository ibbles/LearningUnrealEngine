2021-02-19_18:50:48

# Creating a new module
Here we create a module named `MyProjectEditor` in the project `MyProject`.
In this example we create an Editor module, but the process is similar for other types of modules.

- Add a new entry for the new module to `MyProject.uproject`.
- Create a folder named `MyProjectEditor` in `Source`.
- Create `MyProjectEditor.Build.cs` in `MyProjectEditor`.
- Create `MyProjectEditor.Target.cs` in `Source`.
- Create `MyProjectEditor.h` in `MyProjectEditor`.
- Create `MyProjectEditor.cpp` in `MyProjectEditor`.


## Add a new entry for the new module to `MyProject.uproject`

Add an entry similar to the following to the `"modules"` array.
```json
{
    "Name": "MyProjectEditor",
    "Type": "Editor",
    "LoadingPhase": "PostEngineInit"
}
```
`name` is the name of the new module.
For the primary Editor module in a project it should, by convention, be the name of the project followed by `Editor`.

`Type` is the type of the module (duh) and is often `Runtime` or `Editor`.
[[2020-09-15_21:10:32]] [Module types](./Module%20types.md)  

`LoadingPhase` is when during the startup process that this module should be loaded.
[[2021-02-19_19:49:10]] [Module loading phase](./Module%20loading%20phase.md)  

I'm a bit unsure on the `LoadingPhase`/`PostEngineInit` part.


## Create a folder named `MyProjectEditor` in `Source`

That's `Unreal Projects/MyProject/Source/MyProjectEditor/`.
It is customary, but not required, to create `Public` and `Private` directories in `MyProjectEditor`.
This is where all the source code for this modules will be placed.
The name of the directory should match the name given to the module in `MyProject.uproject`.

## Create `MyProjectEditor.Build.cs` in `MyProjectEditor`

That's `Unreal Projects/MyProject/Source/MyProjectEditor/MyProjectEditor.Build.cs`.
The name of the file should match the name of the module in `MyProject.uproject`.

```csharp
using UnrealBuildTool;

public class MyProjectEditor : ModuleRules
{
    public MyProjectEditor(ReadOnlyTargetRules Target) : base(Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
        PublicDependencyModuleNames.AddRange(new string[] {
            "Core", "CoreUObject", "Engine", "InputCore"
        });
        PublicDependencyModuleNames.AddRange(new string[] {
            "UDN_FallbackPointer"
        });
        PrivateDependencyModuleNames.AddRange(new string[] {
            "Slate", "SlateCore"
        });
    }
}
```

This is where we specify how the new module is to be built.


## Create `MyProjectEditor.Target.cs` in `Source`

This is where we specify which folders with source code that should be build when building this module.
For the Editor module of a project it is customary to also build the main project module.
The Editor module by itself can't do much, it depends on the project module.

```csharp
using UnrealBuildTool;
using System.Collections.Generic;

public class MyProjectEditorTarget : TargetRules
{
    public UDN_FallbackPointerEditorTarget( TargetInfo Target) : base(Target)
    {
        Type = TargetType.Editor;
        DefaultBuildSettings = BuildSettingsVersion.V2;
        ExtraModuleNames.AddRange( new string[] {
            "MyProject", "MyProjectEditor"
        });
    }
}
```

## Create `MyProjectEditor.h` in `MyProjectEditor`

A module may chose to implement the `IModuleInterface`.
This provides an entry point for the module.
This allows it to register things such as Detail Customizations and Editor Modes.

```cpp
#pragma once

#include "CoreMinimal.h"
#include "Modules/ModuleInterface.h"
#include "Modules/ModuleManager.h"
#include "UnrealEd.h"

class MyProjectEditorModule : public IModuleInterface
{
public:
    virtual void StartupModule() override;
    virtual void ShutdownModule() override;
};
```

## Create `MyProjectEditor.cpp` in `MyProjectEditor`

```cpp
#include "MyProjectEditor.h"
#include "Modules/ModuleManager.h"
#include "Modules/ModuleInterface.h"

IMPLEMENT_GAME_MODULE(FMyProjectEditorModule, MyProjectEditor);
```
The first argument to `IMPLEMENT_GAME_MODULE` is the name of the `IModuleInterface` defined in `MyProjectEditor.h`.
The second argument to `IMPLEMENT_GAME_MODULE` is the name given to the module in `MyProject.Build.cs`


[[2021-02-19_21:30:15]] [Modules Build.cs and Target.cs](./Modules%20Build.cs%20and%20Target.cs.md)  
[[2020-09-10_19:55:50]] [Modules](./Modules.md)  

[Creating an Editor Module in Unreal Engine 4 @ sandordaemen.nl](https://sandordaemen.nl/blog/creating-an-editor-module-in-unreal-engine-4/)