2020-09-15_16:50:01

# Turning a project into a code project

> This didn't work. I followed the steps and got a project that didn't have any `.+Editor` build targets. Don't know why not, or how to fix it. I think there should be `.+Editor` targets.
> Because I missed to create the `LightingEditor.Target.cs` file. Maybe it works now.

A Blueprint project can be turned into a C++ project by:
- Create a `Source` directory.
- Create a `Modules` array in the `.uproject` file.
- Create a `Module` entry in the `Modules` array.
- A `Module` should have a name, a type, and a loading phase.
- There is often (must be?) with module with the same name as the project.
- Create a directory for the module in the `Source` directory.
- Create a `<ModuleName>.Target.cs` file in the `Source` directory.
    - Contains a class inheriting from `TargetRules`.
- Create a `<ModuleName>.Build.cs` file in the module's directory.
    - Contains a class inheriting from `ModuleRules`.
- Create a `.h`/`.cpp` pair named `<ModuleName>`.
    - `.h` includes `CoreMinimal.h`
    - `.cpp` uses the `IMPLEMENT_PRIMARY_GAME_MODULE` macro.
- Run `GenerateProjectFiles.sh <ProjectName>.uproject`


Full example:

`Lighting.uproject`:
```
{
	"FileVersion": 3,
	"EngineAssociation": "{AA2FBE50-FCF6-4DF1-95D0-14B3372BA99D}",
	"Category": "",
	"Description": "Project where I experiment with ligting, InfinityBladeGrasslands, and the exercises given out by Making Games With Katie."
	"Modules": [
		{
			"Name": "Lighting",
			"Type": "Runtime",
			"LoadingPhase": "Default"
		}
	]
}
```

`Lighting.Target.cs`:
```csharp
using  UnrealBuildTool;
using  System.Collections.Generic;

public  class  LightingTarget : TargetRules
{
    public  LightingTarget(TargetInfo  Target) : base(Target)
    {
        Type = TargetType.Game;
        ExtraModuleNames.AddRange(new string[] {"Lighting"});
    }
}
```

`LightingEditor.Target.cs`:
```csharp
using UnrealBuildTool;
using System.Collections.Generic;

public class LightingEditorTarget : TargetRules
{
	public LightingEditorTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Editor;
		DefaultBuildSettings = BuildSettingsVersion.V2;
		ExtraModuleNames.AddRange(new string[] {"Lighting"});
	}
}

```


`Lighting.Build.cs`:
```csharp
using UnrealBuildTool;

public class Lighting : ModuleRules
{
    public Lighting(ReadOnlyTargetRules Target) : base(Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
        PublicDependencyModuleNames.AddRange(new string[] {
            "Core", "CoreUObject", "Engine", "InputCore"});
    }
}

```

`Lighting.h`:
```c++
#pragma once

#include "CoreMinimal.h"
```

`Lighting.cpp`:
```c++
#include "Lighting.h"
#include "Modules/ModuleManager.h"

IMPLEMENT_PRIMARY_GAME_MODULE(FDefaultGameModuleImpl, Lighting, "Lighting");
```



[[2020-09-10_19:55:50]] [Modules](./Modules.md)
[[2020-09-10_19:42:18]] [Code projects](./Code projects.md)