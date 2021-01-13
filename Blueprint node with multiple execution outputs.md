2021-01-13_15:02:40

# Blueprint node with multiple execution outputs

A Blueprint node can have multiple execution outputs.
Branch and Switch are examples of such nodes.
We can give multiple output execution pins on nodes for our own C++ functions as follows:

Header:
```cpp
UENUM(BlueprintType)
enum class EMyExecutionPins : uint8
{
    Success,
    Failure
}

UCLASS(BlueprintType)
class AMyActor : public AActor
{
    GeneratedBody()

    UFUNCTION(BlueprintCallable, Meta = (ExpandEnumAsExecs = "Result"))
    void MyFunction(TEnumAsByte<EMyExecutionPins>& Result);
}
```

Implementation:
```cpp
void AMyActor::MyFunction(TEnumAsByte<EMyExecutionPins>& Result)
{
    bool success = /* Do your work here. */;
    Result = success ? EMyExecutionPins::Success : EMyExecutionPins::Failure;
}
```

The `EnumAsByte` part may be unnecessary, just `EMyExecutionPins&` might work just as well.