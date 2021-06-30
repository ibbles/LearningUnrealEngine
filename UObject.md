2020-10-03_10:52:02

# UObject

Base class for all Unreal Engine classes that make use of the reflection, runtime introspection, garbage collection, and serialization.

Classes inheriting from `UObject` should have a `U` prefixed to their *class names*.
Except when there is an intermediate parent class that changes the required prefix.
For example, `AActor` inherits from `UObject` but has the `A` prefix to signal that it is an actor.
All subclasses of `AActor` should also use `A` instead of `U`.

Non-static data members that are members of the set of salient attributes of the class should be marked with `UPROPERTY`.
This makes the data member a *UProperty*.
This exposes it to the engine and includes it in the reflection, runtime introspection, garbage collection, and serialization systems.
It also makes it possible to access the attribute from Blueprints.

All UObject instances know what class they are through the *reflection system*.
This makes it possible to do casting.
[[2021-06-22_13:01:48]] [Reflection system](./Reflection%20system.md)  



[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  
[[2021-06-21_17:08:23]] [UObject initialization](./UObject%20initialization.md)  
[[2021-06-22_08:34:55]] [UProperties](./UProperties.md)  
[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
[[2020-03-10_21:23:32]] [Naming convention](./Naming%20convention.md)  
[[2021-06-22_13:01:48]] [Reflection system](./Reflection%20system.md)  
