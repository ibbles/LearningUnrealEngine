2020-12-30_18:10:25

# Unreal Header Tool

Parses C++ headers in an Unreal Engine project and generates code for the reflection and garbage collection systems.
Looks for and reacts to special macros that are used to mark classes, structs, variables, functions, and enums.
These macros are `UCLASS`, `USTRUCT`, `UPROPERTY`, `UFUNCTION`, and `UENUM`.
There may be more.
This is how types and functions are exposed to Blueprints.
Code generated in response to these macros are placed in the `.generated.h` file.
