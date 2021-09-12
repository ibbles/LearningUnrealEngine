2021-09-12_10:48:17

# Child Actor

A Child Actor is an Actor that is created as part of another Actor, and whose Root Component is attached to one of the Components owned by the parent Actor.
They are created by adding a Child Actor Component to the parent Actor.
In the Details Panel for the Child Actor Component, select an Actor class and then the configurable UProperties of the Child Actor will appear.
This only works in a Blueprint, not on instances in the Level Editor.
Using Child Actors is generally considered bad practice because of limited flexibility.
- Cannot edit any UProperties on the Child Actor on instances.
- Cannot edit the Child Actor in any way except for the public instance editable UProperties.


## Alternatives

Create a regular Actor in the Level Editor and simply drag it on top of the parent Actor.
This will attach the Root Component of the child Actor to the Root Component of the parent Actor.
I don't know how to attach to any other Component in the parent Actor, or to a Socket.

Spawn the child Actor using code, either C++ or Blueprint Visual Script, and attach with `Attach To Component`.
`MyActor = GetWorld()->SpawnActor<AMyClass>(MyActorClass, etc)`.
I assume `MyActorClass` is a UProperty of type `TSublcassOf<AActor>`, or something more specific than `AActor`.
```cpp
UPROPERTY(EditAnywhere, BlueprintReadOnly)
TSubclassOf<AMyClass> MyActorClass;`,
```

Can use some kind of marker Component, such as Arrow, Billboard, or even plain Scene, on the parent Component to mark the location that the child Actor should attach to.
