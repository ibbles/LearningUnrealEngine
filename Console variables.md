2021-08-17_10:50:33

# Console variables

```cpp
IConsoleVariable* Variable = IConsoleManager::Get().FindConsoleVariable(
    TEXT("MyWariable"));
Variable->Set(Value, Flags); // There are a bunch of overloads. Not sure what Flags is.
Variable->SetWithCurrentPriority(Value);

Variable->SetOnChangedCallback(MyCallback); // Show how to declare MyCallback.
```