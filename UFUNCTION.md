2020-03-09_21:48:56

# UFUNCTION

The `UFUNCTION` decorator macro exposes a C++ function to the Unreal Engine reflection system.

```c++
UCLASS()
class AMyActor : public AActor
{
    GENERATED_BODY()
public:
    UFUNCTION()
    void MyFunction();
}
```

A number of function specifiers can be added to set properties on the function.
- `BlueprintCallable`: The function can be called from a Blueprint Visual Script.
- `BlueprintImplementableEvent`: The function is only declared and not implemented in C++, the function definition is provided by a Blueprint class inheriting from the C++ class. I assume `Blueprintable` must be provided on the C++ class for this to make sense.
- `BlueprintNativeEvent`: Like `BlueprintImplementableEvent`, but with a fallback C++ definition in case no Blueprint implementation is made. A separate C++ function with the same name but with `_Implementation` at the end is declared automatically and this is where the C++ implementation should be written. I assume `Blueprintable` must be provided on the class for this to make sense.

[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  

A `BlueprintImplementableEvent` is implemented in a Blueprint subclass by right-click in the Event Graph add selecting `Add Event` > `Event <FUNCTION_NAME>`.
This will create a red event start node with an output execution pin.


A complete example of a Blueprint configurable C++ Actor class.

Declaration:
```c++
UCLASS(Blueprintable)
class AMyActor : public AActor
{
    GENERATED_BODY()
public:
    UFUNCTION(BlueprintCallable)
    void MyFunction();
    
    UFUNCTION(BlueprintImplementableEvent)
    void MyBlueprintFunction();
    
    UFUNCTION(BlueprintNativeEvent)
    void MyOptionalBlueprintFunction();
}
```

Implementation:
```c++
void AMyActor::MyFunction()
{
    UE_LOG(
        LogTemp, Display,
        TEXT("This function can be called from a Blueprint Visual Script."));
}

/*
This function should not be implemented in C++, it should be implemented in Blueprint by a Blueprint class having this class as its parent.
void AMyActor::MyBlueprintFunction()
{
}
*/

void MyActor::MyOptionalBlueprintFunction_Implementation()
{
    UE_LOG(
        LogTemp, Display,
        TEXT("The Blueprint subclass can chose to override this."));
}
```

[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  
[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  