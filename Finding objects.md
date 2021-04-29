2021-04-23_08:54:36

# Finding objects

## Actors in a world
Iterate over all Actors or a particular type in a world:
```cpp
for (AMyActor* MyActor : TActorRange<AMyActor>(World))
{
    // Do stuff with MyActor.
}
```
The same using an explicit iterator:
```cpp
UClass* MyActorClass = AMyActor::StaticClass();
for(TActorIterator<AMyActor> It(World, MyActorClass); It; ++It)
{
    AMyActor* MyActor = *It;
    // Do stuff with MyActor.
}
```

There is also `UGameplayStatics::GetAllActorsOfClass()` but there is no templated version so casting will be required on the result.

Finding an Actor by name:
```cpp
/// @todo
```

## Assets in the Content folder
```cpp
/// @todo
```