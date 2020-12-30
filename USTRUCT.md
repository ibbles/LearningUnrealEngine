2020-03-10_21:12:12

# USTRUCT

```c++
#pragma once

#include "CoreMinimal.h"

USTRUCT()
struct MODULENAME_API FMyStruct
{
    GENERATED_BODY()

    UPROPERTY()
    float MyProperty;
};
```

The `USTRUCT` macro can take struct specifiers, such as
- `BlueprintType`: Exposes this struct as a type that can be used for variables in Blueprints.
- 

`BlueprintType` is required if the struct is to be used as a `UPROPERTY` in another struct or a class.

[Structs specifiers @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProgrammingAndScripting/GameplayArchitecture/Structs/Specifiers/index.html)  