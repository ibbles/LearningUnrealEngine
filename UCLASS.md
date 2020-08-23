2020-03-09_21:34:05

#  UCLASS
The `UCLASS` decorator macro is used to expose C++ classes to Unreal Engine and the Blueprint system. It adds the class to the reflection system.
Class members variables decorated with the `UPROPERTY` macro become Unreal Engine properties that can be edited using the Unreal Editor GUI tools and the Blueprint visual scripting language.
Class member functions decorated with the`UFUNCTION` macro become Unreal Engine functions that can be called from the Blurprint visual scripting language.
Marking a C++ class with the `UCLASS` macro will cause the [[Unreal Build Tool]] to generate an include file that should be included in the class's header file, last in the include list.
Decorating a class with the `UCLASS` macro allow it to use the [[memory management and smart pointers]] system build into Unreal Engine.
I'm not sure if inheriting from `UObject` is required for `UCLASS` classes.
Instances of `UCLASS` classes must be created with `ConstructObject`, `NewObject`, or `CreateDefaultSubobject`. It is not allowed to create such instances using `new`.

New classes can be created either using the `New C++ Class` wizard from within the Unreal Editor or by creating the `.h` and `.cpp` files by hand. 

A number of class specifiers can be added to the `UCLASS` macro to specify ho the class behaves with various aspects of the Unreal Engine and Unreal Editor.

- `Blueprintable`: Allow creation of Blueprint subclasses of the C++ class.
- `BlueprintType`: Allow creation of variables of this type in Blueprint classes.
- `NotBlueprintable`: Do not allow creation of Blueprint subclasses of the C++ class.

[[2020-03-09_21:43:36]] UPROPERTY
[[2020-03-09_21:48:56]] UFUNCTION
[[2020-03-09_21:54:48]] Blueprints
[[2020-03-11_18:48:51]] Blueprint from C++ class
[[2020-03-09_21:57:41]] Unreal Build Tool
