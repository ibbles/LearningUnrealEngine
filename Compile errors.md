2021-02-18_20:36:29

# Compile errors

## Undefined symbol on StaticEnum
```
ld.lld: error: undefined symbol: UEnum* StaticEnum<FMyClass::EMyEnum>()
```

This happens when an `UENUM` is nested inside a class.
Move the enum up to file scope.
It's possible that marking the class with `UCLASS` (or `USTRUCT` for structs) will also fix it, haven't tried.


## File not found
```
fatal error: 'MyHeader.h' file not found
```

This happens when we have a `#include <MyHeader.h>` or `#include "MyHeader.h"` in our code without telling the compiler where `MyHeader` is.
Unreal Build Tool handle most of this for us, but we need to give it some hints.

Some possible causes:
- The module that provides the header file is not listed in `(Public|Private)DependencyModuleNames` in `.Build.cs`. Check the Module row of the class' page in the [Unreal Engine API Reference](https://docs.unrealengine.com/en-US/API/index.html) to see which module to include.
- The header file is actually in a subdirectory so more of the path must be given. This is a tricky one because it builds without the directory in the `#include` when building in Development mode but not when cooking/exporting. Check the Include row of the class' page in the [Unreal Engine API Reference](https://docs.unrealengine.com/en-US/API/index.html) to see the correct include path.


## Undefined symbol GetPrivateStaticClass
```
ld.lld: error: undefined symbol: UMyComponent::GetPrivateStaticClass()
```
And then a reference to the `GENERATED_BODY()` line in the Component's header file.


The `MYMODULE_API` tag/marker/decorator is missing from the Component's class declaration.
This solution is applicable to a number of `undefined symbol` related errors.