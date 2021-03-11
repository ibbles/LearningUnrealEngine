2021-03-11_19:14:28

# String conversions

There are a lot of string types in Unreal Engine.

```cpp
FName Name;
FString String;
std::string STDString;

TCHAR_TO_UTF8(*TheFString); // Temporary storage, only for function parameters.
TCHAR_TO_ANSI
```