2020-03-09_21:34:05

#  UCLASS
The `UCLASS` decorator macro is used to expose C++ classes to Unreal Engine and the Blueprint system.
It adds the class to the reflection system.
Class members variables decorated with the `UPROPERTY` macro become Unreal Engine properties that can be edited using the Unreal Editor GUI tools and the Blueprint visual scripting language.

[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  

Class member functions decorated with the`UFUNCTION` macro become Unreal Engine functions that can be called from the Blueprint visual scripting language.

[[2020-03-09_21:48:56]] [UFUNCTION](./UFUNCTION.md)  

Marking a C++ class with the `UCLASS` macro will cause the [[Unreal Build Tool]] to generate an include file that should be included in the class's header file, last in the include list.
Decorating a class with the `UCLASS` macro allow it to use the [[memory management and smart pointers]] system build into Unreal Engine.
I'm not sure if inheriting from `UObject` is required for `UCLASS` classes.
Instances of `UCLASS` classes must be created with `ConstructObject`, `NewObject`, or `CreateDefaultSubobject`.
It is not allowed to create such instances using `new`.

[[2020-12-31_12:14:21]] [Creating objects](./Creating%20objects.md)  

New classes can be created either using the `New C++ Class` wizard from within the Unreal Editor or by creating the `.h` and `.cpp` files by hand. 

A number of class specifiers can be added to the `UCLASS` macro to specify ho the class behaves with various aspects of the Unreal Engine and Unreal Editor.

- `Blueprintable`: Allow creation of Blueprint subclasses of the C++ class. Is inherited from base classes, such as `AActor`.
- `BlueprintType`: Allow creation of variables of this type in Blueprint classes. Possibly inherited, possibly implied by `Blueprintable`.
- `NotBlueprintable`: Do not allow creation of Blueprint subclasses of the C++ class.

[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
[[2020-03-09_21:48:56]] [UFUNCTION](./UFUNCTION.md)  
[[2020-03-09_21:54:48]] [Blueprints](./Blueprints.md)  
[[2020-03-11_18:48:51]] [Blueprint from C++ class](./Blueprint%20from%20C++%20class.md)  
[[2020-03-09_21:57:41]] [Unreal Build Tool](./Unreal%20Build%20Tool.md)  
[[2020-12-30_17:24:55]] [Class specifiers](./Class%20specifiers.md)  
[[2020-12-31_12:14:21]] [Creating objects](./Creating%20objects.md)  