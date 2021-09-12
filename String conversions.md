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


```
 From\To    │FName             │FString        │FText               │UTF-8*       │TCHAR*       │std::string│
├───────────┼──────────────────┼───────────────┼────────────────────┼─────────────┼─────────────┼───────────┤
│FName      │                  |FName::ToString│FText::FromName     |
├───────────┼──────────────────┼───────────────┼────────────────────┼
│FString    │ FName(FStstring) │               │FText::FromString   │ 
├───────────┼──────────────────┼───────────────┼
│FText      │                  |               |
├───────────┼──────────────────┼───────────────┼
│UTF-8*     │                  │               │via UTF-8* to TCHAR*│             │UTF8_TO_TCHAR│
├───────────┼──────────────────┼───────────────┼
│TCHAR*     │                  │               │FText::FromString   │TCHAR_TO_UTF8│
├───────────┼──────────────────┼───────────────┼
│std::string|                  |               |
└───────────┴──────────────────┴───────────────┘
```


String Handling
https://docs.unrealengine.com/4.26/en-US/ProgrammingAndScripting/ProgrammingWithCPP/UnrealArchitecture/StringHandling/

Character Encoding
https://docs.unrealengine.com/4.26/en-US/ProgrammingAndScripting/ProgrammingWithCPP/UnrealArchitecture/StringHandling/CharacterEncoding/


[[2021-06-08_16:47:36]] [Text and string formatting](./Text%20and%20string%20formatting.md)  
