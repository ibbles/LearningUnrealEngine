2020-09-30_13:13:51

# Callbacks

`TFunction<>` is a lower level primitive that is able to bind anything, including `UObject` function members.
It's similar to `std::function<>`.

There are also delegates, both single and multi.

`FMenuBuilder::AddMenuEntry` uses `FUIAction` for its callbacks.
The `FUIAction` can be created from `FExecuteAction::CreateLambda()`, which in turn is created from a C++ lamda.
`FExecuteAction` is a `TBaseDelegate_NoParams`.

## Slate

In Slate we can use both lambdas and function pointers.
In the below a combo box is created but I assume the process is the same in most cases.
```c++
vid UMyClass::MyFunction()
{
    SNew(SComboBox<TSharedPtr<FName>>)
    // The callbacks that add a lambda all have _Lambda at the end of their
    // name. I guess this is because the lambda version is templated and they
    // don't have a way to disable the overload for non-lambda types.
    .OnGenerateWidget_Lambda([](TSharedPtr<FName> Item))
    {
        return SNew(STextBlock)
            .Text(FText::FromName(*Item))
    })
    // Member function callbacks are registered by passing in a pointer to the
    // object which should receive the call, a function pointer to the member
    // function that should be called, and an optional list of extra parameters.
    // The extra parameters are passed on to the member function but otherwise
    // ignored by the callback framework.
    // The signature of the member function must match the type of the callback.
    // That is, it must take all the parameters that the callback source always
    // passes, and the rest of the parameters should match the extra parameters
    // that we list here.
    .OnSelectionChanged(
        this, &FMyClassCustomization::MyCallback, ExtraParameter)
}
```

[[RF_Transactional]] [RF_Transactional](./RF_Transactional.md)

[Delegates@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/UnrealArchitecture/Delegates/index.html)