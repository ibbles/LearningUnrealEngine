2021-02-19_22:54:47

# Creating a new target

I don't know.
I had expected that the following would work, but I get 
```
$ make MyUtilities
bash "/media/s800/UnrealEngine_4.25/Engine/Build/BatchFiles/Linux/Build.sh" MyUtilities Linux Development  
Fixing inconsistent case in filenames.
Setting up Mono
Building MyUtilities...
Using 'git status' to determine working set for adaptive non-unity build (/media/s800/UnrealEngine_4.25).
Creating makefile for MyUtilities (no existing makefile)
ERROR: Couldn't find target rules file for target 'MyUtilities' in rules assembly 'UE4Rules, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null'.
       Location: /media/s800/UnrealEngine_4.25/Engine/Intermediate/Build/BuildRules/UE4Rules.dll
       Target rules found:
make: *** [Makefile:50: MyUtilities] Error 6
```

`Modules` in `MyProject.uproject`:
```json
{
	"Name": "MyUtilities",
	"Type": "Runtime",
	"LoadingPhase": "Default"
}
```

`MyUtilities.Target.cs`:
```csharp
using UnrealBuildTool;
using System.Collections.Generic;

public class MyUtilitiesTarget : TargetRules
{
	public MyUtilitiesTarget( TargetInfo Target) : base(Target)
	{
		Type = TargetType.Client;
		DefaultBuildSettings = BuildSettingsVersion.V2;
		ExtraModuleNames.AddRange( new string[] {
			"MyUtilities"
		});
	}
}
```


`MyUtilities.Build.cs`:
```csharp
using UnrealBuildTool;

public class MyUtilities : ModuleRules
{
	public MyUtilities(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

		PublicDependencyModuleNames.AddRange(new string[] {
			"Core", "CoreUObject", "Engine", "InputCore"
		});

		PrivateDependencyModuleNames.AddRange(new string[] {  });
	}
}
```

`MyUtilities.h`:
```cpp
#pragma once

#include "CoreMinimal.h"
#include "Modules/ModuleInterface.h"
#include "Modules/ModuleManager.h"

class FMyUtilitiesModule : public IModuleInterface
{
public:
	virtual void StartupModule() override;
	virtual void ShutdownModule() override;
};

namespace MyUtilities
{
	void Log();
}
```

```cpp
#include "MyUtilities.h"

#include "Modules/ModuleManager.h"
#include "Modules/ModuleInterface.h"

IMPLEMENT_GAME_MODULE(FMyUtilitiesModule, MyUtilities);

#define LOCTEXT_NAMESPACE "TutorialEditor"

void FMyUtilitiesModule::StartupModule()
{
}

void FMyUtilitiesModule::ShutdownModule()
{
}

void MyUtilities::Log()
{
	UE_LOG(LogTemp, Error, TEXT("MyUtilities is logging."));
}

#undef LOCTEXT_NAMESPACE
```


It is doing something because if I change `Type` in `MyUtilities.Target.cs` from `TargetType.Client` to `TargetType.Game` then the Generate Project Files script error out with
```
ERROR: Not expecting project /media/s800/UnrealProjects/UDN_FallbackPointer/Intermediate/ProjectFiles/UDN_FallbackPointer.mk to already have a target rules of with configuration name Game (MyUtilitiesTarget) while trying to add: UDN_FallbackPointerTarget
```

Perhaps we're only allowed to have a single non-Editor target?
The following quote from [Gameplay Modules](https://docs.unrealengine.com/en-US/ProgrammingAndScripting/GameplayArchitecture/Gameplay/index.html) imply as much:
> You can create a primary game module, then any number of additional game-specific modules.
> You can create *.Build.cs files for these new modules, then add references to these modules to your
> game's [Target.cs file](https://docs.unrealengine.com/en-US/ProductionPipelines/BuildTools/UnrealBuildTool/TargetFiles/index.html).

So additional Modules are ok, but perhaps not Targets.