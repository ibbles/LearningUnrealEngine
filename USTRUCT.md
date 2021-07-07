2020-03-10_21:12:12

# USTRUCT

A UStruct, i.e., a C++ `struct` that is known to the Unreal Engine reflection system, is created by decorating the struct definition with the `USTRUCT` decorator.

```c++
#pragma once

#include "CoreMinimal.h"

#include "MyStruct.Generated.h"

USTRUCT()
struct MYMODULE_API FMyStruct
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

UStructs cannot contain UFunctions, i.e., the `UFUCTION` decorator is forbidden.
The alternative is to create a Blueprint Function Library containing functions that has a reference to the UStruct as its first parameter.

```cpp
UCLASS()
class MYMODULE_API UMyStruct_FL : public UBlueprintFunctionLibrary
{
    GENERATED_BODY()

    UFUNCTION(BlueprintCallable, Category = "My Struct")
    static bool MyFunction(UPARAM(ref) FMyStruct& MyStruct, float MyFloat);
};
```

```cpp
bool UMyStruct_FL::MyFunction(
    UPARAM(ref) FMyStruct& MyStruct, float MyFloat)
{
    if (MyFloat <= 0.0)
    {
        UE_LOG(LogTemp, Error, TEXT("MyStruct::MyProperty must be positive."));
        return false;
    }
    MyStruct.MyProperty = MyFloat;
    return true;
}
```

A UProperty cannot be a pointer to an FStruct.
A UFunction cannot return a pointer to an FStruct.

[[2020-10-14_18:31:53]] [UBlueprintFunctionLibrary](./UBlueprintFunctionLibrary.md)  

[Structs specifiers @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProgrammingAndScripting/GameplayArchitecture/Structs/Specifiers/index.html)  
