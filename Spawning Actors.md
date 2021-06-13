
2021-04-30_08:20:04

# Spawning Actors


## Blueprint

New Actor instances are spawned with Spawn Actor from Class.
The inverse, despawning an Actor, is done with the Destroy Actor function.

It does not seem to be possible to used deferred spawning from a Blueprint.

## C++

A new Actor is spawned/created by calling `SpawnActor` on the world in which we wish the new Actor to appear.
```cpp
AMyActor* MyActor = GetWorld()->SpawnActor<AMyActor>(
    // The type of Actor to spawn. Should be the same
    // or class derived from the template argument.
    AMyActor::StaticClass(),
    // Initial position of the new Actor.
    FTransform::Identity());
```

We can do deferred spawning, meaning that we can do some configuration of the created Actor instance before it is finalized.
Not entirely sure what "finalized" means in this context.
Having BeginPlay called, perhaps.
```cpp
AMyActor* MyActor = GetWorld()->SpawnActorDeferred<AMyActor>(
    AMyActor::StaticClass(), FTransform::Identity);
MyActor->MyProperty = 1;
MyActor->FinishSpawning()
```

[[2020-03-10_21:29:17]] [Actor](./Actor.md)  
[[2020-12-30_17:02:30]] [C++ Actor](./C++%20Actor.md)  
