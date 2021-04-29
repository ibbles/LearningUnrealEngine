2021-04-23_08:41:13

# Type conversions

The Blueprint Editor can insert type conversion nodes automatically in some cases.
For example from `Vector` to `String`. (I think)
We can provide such functionality by writing a C++ conversion function.
Mark the function with `Meta=(BlueprintAutocast)` Function Specifier.
We can use `CompactNodeTitle` as well, to reduce the size of the node in the Visual Script Editor
```cpp
UFUNCTION(
    BlueprintPure,
    Category = "My Category",
    Meta = (
        BlueprintAutocast,
        CompactNodeTitle = "->"
    )
)
static FB ConvertAToB(const FA& In);
```