2020-05-10_11:07:00

## Interface

An interface is a set of functions.
Other entities, such as an `Actor`, can implement the interface.


I'm unsure of how the `UMyInterface` and the `IMyInterface` interact in the examples below.

We can check for and call interface functions on an object in multiple ways in C++.
First way:
```cpp
if (MyActor->GetClass()->ImplementsInterface(UMyInterface::StaticClass()))
{
    IMyInterface::Execute_TestFunction(MyActor);
}
```
Second way:
```cpp
if(IMyInterface* MyInterface = Cast<IMyInterface>(MyActor))
{
   MyInterface->TestFunction();
}
```
Third way:
```cpp
if (MyActor && MyActor->Implements<UMyInterface>())
{
    IMyInterface::Execute_TestFunction(MyActor);
}
```
Forth way:
```cpp
if (UKismetSystemLibrary::DoesImplementInterface(MyActor, UMyInterface::StaticClass()))
{
    IMyInterface::Execute_TestFunction(MyActor);
}
```

Some recommend the `ImplementsInterface` approach because it works for Blueprint implementations as well.
I take that to mean that the `Cast` approach can't dispatch into a Blueprint Visual Script. Testing needed.
Some recommend the `Cast` approach because it checks for `nullptr`.
Some say that the `Implements` approach works on both C++ and Blueprint implementations.
Some say that the `UKismetSystemLibrary` approach is the most robust. Unsure in what way.

[[2020-03-10_21:29:17]] [Actor](./Actor.md)  