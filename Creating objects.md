2020-12-31_12:14:21

# Constructing objects

## Blueprint

Create new instances of a `UObject` class that is not an Actor or a Component with the Construct Object from Class node.
The class must include `BlueprintType` in its Class Specifiers.

[[2020-12-30_17:24:55]] [Class specifiers](./Class specifiers)  
[[2020-08-14_09:32:03]] [Creating Components at runtime](./Creating%20Components%20at%20runtime.md)  
[[2020-11-30_10:36:27]] [Creating components in constructor](./Creating%20components%20in%20constructor.md)  
[[2021-04-30_08:20:04]] [Spawning Actors](./Spawning%20Actors.md)  


## C++
Instances of `UCLASS` classes must be created with `ConstructObject`, `NewObject`, or `CreateDefaultSubobject`.
It is not allowed to create such instances using `new`.

`CreateDefaultSubobject` is used to create objects in the constructor of the owning object.

[[2020-11-30_10:36:27]] [Creating components in constructor](./Creating%20components%20in%20constructor.md)  

`NewObject`/`ConstructObject`. What's the difference?


[[2020-08-14_09:32:03]] [Creating Components at runtime](./Creating%20Components%20at%20runtime.md)  
