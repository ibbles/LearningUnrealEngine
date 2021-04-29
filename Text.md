2021-04-28_12:52:21

# Text


```cpp
const FString MyThing = ...;
FFormatNamedArguments Args;
Args.Add(TEXT("MyThing"), FText::FromString(MyThing));
FText StatusMessage = FText::Format(
    NSLOCTEXT("MySomething(?)", "DoingTheThing", "Doing thing: {MyThing}..."),
    Args);
```