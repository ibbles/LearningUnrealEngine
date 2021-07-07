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

`UFUNCTION` does not support *overloading*, i.e., function member names must be unique.
`UFUNCTION` does not support *template*, but there might be a work-around based on custom thunks and/or wildcards.
`UFUNCTION` does not support *reference return* types. Us an in/out parameter instead.
```cpp
UFUNCTION(BlueprintCallable, Category = "MyCategory")
void MyFunction(UPARAM(Ref) FMyType& InOutMyParameter);
```

A number of function specifiers can be added to set properties on the function.
- `BlueprintCallable`: The function can be called from a Blueprint Visual Script.
- `BlueprintPure`: The function can be called from a Visual Script, will note have an execution pin.
- `BlueprintImplementableEvent`: The function is only declared and not implemented in C++, the function definition is provided by a Blueprint class inheriting from the C++ class. I assume `Blueprintable` must be provided on the C++ class for this to make sense.
- `BlueprintNativeEvent`: Like `BlueprintImplementableEvent`, but with a fallback C++ definition in case no Blueprint implementation is made. A separate C++ function with the same name but with `_Implementation` at the end is declared automatically and this is where the C++ implementation should be written. I assume `Blueprintable` must be provided on the class for this to make sense.

A non-C++-`const` `BlueprintCallable` function will have an execution pin.
A C++-`const` `BlueprintCallable` function will not have an execution pin.

The only difference between `BlueprintPure` and `BlueprintCallable` is that `BlueprintCallable` only updates its outputs once when the execution runs through it. `BlueprintPure` will rerun the function and update the output for every single thing that tries to get a value from it.

A UFunction cannot return a pointer to an FStruct.

[[2021-03-13_11:48:31]] [Blueprint events in C++](./Blueprint%20events%20in%20C++.md)  
[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  
[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
[[2020-03-10_21:12:12]] [USTRUCT](./USTRUCT.md)  
