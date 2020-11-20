2020-11-20_11:38:31

# Spawning Blueprint classes from C++

In the class that should do the spawning, add a `TSubclassOf<AActor>` variable.
If you have another C++ base class that the Blueprint class inherits from then use that instead of `AActor`.
In Unreal Editor, assign a Blueprint class to this variable.
Add the following C++ code:
```c++
UCLASS()
class UMySpawner : USomeUnrealClass
{
public:
    UPROPERTY(EditAnywhere)
    TSubclassOf<AActor> TypeToSpawn;
}

void UMySpawner::DoSpawn()
{
    Vector Location = /* Compute position*/;
    FActorSpawnParameters Parameters;
    AActory* SpawnedActor =
        GetWorld()->SpawnActor<AActor>(TypeToSpawn, Location, Parameters);
}
```