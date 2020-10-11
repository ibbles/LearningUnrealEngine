2020-10-03_10:52:02

# UObject

Base class for all Unreal Engine classes that make use of the reflection, runtime introspection, garbage collection, and serialization.
Classes inheriting from `UObject` should have a `U` prefixed to their names.
Except when there is an intermediate parent class that changes the required prefix.
For example, `AActor` inherits from `UObject` but has the `A` prefix to signal that it is an actor.
So all subclasses of `AActor` should also use `A` instead of `U`.

Non-static data members that are members of the set of salient attributes of the class should be marked with `UPROPERTY`.
This exposes it to the engine and includes it in the reflection, runtime introspection, garbage collection, and serialization systems.
It also makes it possible to access the attribute from Blueprints.

[[2020-03-10_21:23:32]] [Naming convention](./Naming%20convention.md)  
