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
- `<VALUE>` is a value whos type matches the corresponding format specifier.

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