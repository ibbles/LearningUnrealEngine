2020-10-14_18:31:53

#     UBlueprintFunctionLibrary

Free functions and UStruct "member" function are exported to Blueprints using a Blueprint Function Library.
The library is a class inheriting from `UBlueprintFunctionLibrary` that contains a bunch of static UFunctions.
The functions must be Blueprint Callable and have a Category.

```c++
#include "Kismet/BlueprintFunctionLibrary.h"

UCLASS()
class MYMODULE_API UMyFunctionLibrary : public UBlueprintFunctionLibrary
{
    GENERATED_BODY()

    UFUNCTION(BlueprintCallable, Category = "My Category")
    static void MyFunction();
};
```

The parameters taken by each function must be Blueprint compatible, i.e., one of the supported primitive types (not `double`) or a UClass or UStruct with the BlueprintType Specifier.

Parameters can be passed by reference from a Blueprint Visual Script by decorating a reference parameter with `UPARAM(ref)`.
```cpp
UFUNCTION(BlueprintCallable)
static void Blah(UPARAM(ref) FMyStruct& MyStruct);
```

[[2020-03-09_21:48:56]] [UFUNCTION](./UFUNCTION.md)  
[[2020-03-10_21:12:12]] [USTRUCT](./USTRUCT.md)  
[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  
