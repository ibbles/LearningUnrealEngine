2020-12-30_19:20:58

# Log

Log messages are printed with the `UE_LOG` macro.
A call has the following pattern:
```cpp
UE_LOG(<CATEGORY>, <VERBOSITY>, TEXT("<MESSAGE>")[, <VALUE>]...);
```

where
- `<CATEGORY>` is one of the registered logging categories. See below.
- `<VERBOSITY>` is one of `Display`, `Log`, `Warning`, `Error`, `Fatal`.
- `<MESSAGE>` is the message to print to the log. Can contain `printf` style `%` format specifiers.
- `<VALUE>` is a value whose type matches the corresponding format specifier.

For example:
```cpp
UE_LOG(LogMyGame, Warning, TEXT("The delta time %f is too high."), DeltaTime);
```

New log categories is created as follows:

Header file:
```cpp
MYMODULE_API DECLARE_LOG_CATEGORY_EXTERN(LogMyGame, Verbose, All);
```

Source file:
```cpp
DEFINE_LOG_CATEGORY(LogMyGame);
```

Each log entry is prepended with some numbers.
The first `[]` contains the date and time.
In `Year`.`Month`.`Day`-`Hour`.`Minute`.`Second`:`Millisecond` format.
At least for me, there may be locale-related differences here.
The second `[]` contains the current frame.
Example:
```
[2021.03.12-08.05.50:875][ 98]
```

One can also write on-screen messages:
```cpp
GEngine->AddOnScreenDebugMessage(
    INDEX_NONE, // Used for deduplication, i.e. to avoid spam.
    15.0f,  // Time to display, in seconds.
    FColor::Green, // The color of the text.
    TEXT("My message.")); // The text to display.
```

[Logging @ ue4community.wiki](https://www.ue4community.wiki/logging-lgpidy6i)  
[AddOnScreenDebugMessage @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/API/Runtime/Engine/Engine/UEngine/AddOnScreenDebugMessage/1/)  
