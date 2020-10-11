2020-09-30_13:13:51

# Callbacks

`TFunction<>` is a lower level primitive that is able to bind anything, including `UObject` function members.
It's similar to `std::function<>`.

There are also delegates, both single and multi.

`FMenuBuilder::AddMenuEntry` uses `FUIAction` for its callbacks.
The `FUIAction` can be created from `FExecuteAction::CreateLambda()`, which in turn is created from a C++ lamda.
`FExecuteAction` is a `TBaseDelegate_NoParams`.

[[RF_Transactional]] [RF_Transactional](./RF_Transactional.md)

[Delegates@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/UnrealArchitecture/Delegates/index.html)