2021-03-13_11:48:31

# Blueprint events in C++


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

## Reference parameters

Parameters can be passed by reference to a `UFUNCTION`.
Such parameters become output pins in Visual Scripts.
```cpp
UFUNCTION(BlueprintCallable)
void Add(FMyNumeric Lhs, FMyNumeric Rhs, FMyNumeric& Result);
```

We can add `UPARAM(ref)` to make the parameter an InOut parameter.
Such parameters become input pins in Visual Scripts.
```cpp
UFUNCTION(BlueprintCallable)
void InitializeMyStruct(UPARAM(ref) FMyStruct& MyStruct);
```

