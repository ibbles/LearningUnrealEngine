2021-05-28_22:33:04

# Units

Unreal Engine uses centimeters (cm) for all length measurements.

There is something called `TNumericUnitTypeInterface` that is used when a number has some unit.
The constructor take an `EUnit`, which is one of a list of units that Unreal Engine knows about.

`FComponentTransformDetail` inherit from `TNumericUnitTypeInterface` and pass `EUnit::centimeters`.
In `GenerateChildContent` it does
```cpp
TSharedPtr<INumericTypeInterface<float>> TypeInterface;
if( FUnitConversion::Settings().ShouldDisplayUnits() )
{
    TypeInterface = SharedThis(this);
}
```

Also related are [`FUnitConversion`](https://docs.unrealengine.com/4.26/en-US/API/Runtime/Core/Math/FUnitConversion/) and [`FNumericUnit`](https://docs.unrealengine.com/4.26/en-US/API/Runtime/Core/Math/FNumericUnit/).

A Numeric Type Interface can be passed to the Type Interface parameter of some Slate widgets, such as Vector Input Box.


[FUnitConversion @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/API/Runtime/Core/Math/FUnitConversion/)  
[FNumericUnit @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/API/Runtime/Core/Math/FNumericUnit/)  
