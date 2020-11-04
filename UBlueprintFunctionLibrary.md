2020-10-14_18:31:53

#     UBlueprintFunctionLibrary

Free functions are exported to Blueprints using `UBlueprintFunctionLibrary`.

```c++
UCLASS()
class YOURPROJECT_API UYourLibrary :
        public UBlueprintFunctionLibrary
{
    GENERATED_BODY()
    
    UFUNCTION(BlueprintCallable)
    void Blah(<PARAMETERS>);
};
```

A `UCLASS` inheriting from `UBlueprintFunctionLibrary` is declared and filled with `UFUNCTION`s.
The parameters to each function must be Blueprint compatible, i.e., one of the supported primitive types (not `double`) or a `BlueprintType` `UCLASS`.