2020-11-20_11:38:31

# Spawning Blueprint classes from C++

In the class that should do the spawning, add a `TSubclassOf<AActor>` variable.
`TSubclassOf` is a type that represents a family of related types.
If you have another C++ base class that the Blueprint class inherits from then use that instead of `AActor`.
In Unreal Editor, create an instance of the C++ class and assign a Blueprint class type to the `TSubclassOf` variable.
Add the following C++ code, and have some event :
```c++
UCLASS(BlueprintType)
class UMySpawner : USomeUnrealClass
{
public:
    UPROPERTY(EditAnywhere, Category = "Spawning")
    TSubclassOf<AActor> TypeToSpawn;

    UFUNCTION(BlueprintCallable, Category = "Spawning")
    void DoSpawn();
}

void UMySpawner::DoSpawn()
{
    Vector Location = /* Compute position*/;
    FActorSpawnParameters Parameters;
    AActor* SpawnedActor =
        GetWorld()->SpawnActor<AActor>(TypeToSpawn, Location, Parameters);
}
```