2020-07-02_15:45:39

# Enum

An enum is a compile-time list of named elements.
Each element is an integer, starting from 0 and counting up.
Regular C++ enums are a bit more flexible, but Unreal Header Tool imposes some restrictions.
The number of elements is returned by the `Get number of entries in <ENUM>` node.
Select a random enum element with `Random Integer in Range` and `Get number of entries in <ENUM>` - 1, convert the random Integer to Byte, then finally `Literal enum <ENUM>`.
Enum elements can be converted to String. 

Enums can be printed in C++ with:

```c++
StaticEnum<EMyEnum>()->GetNameByValue( EMyEnum::Value )
```
Or
```c++
GetDisplayNameTextByValue()
```
`StaticEnum<EMyEnum>()` returns an `UEnum*`.

May need `GetNameByValue(int64(SomeEnumValue))`.

A helper:
```c++
template<typename T>
static FString EnumToString(const T Value)
{
    return StaticEnum<T>()->GetNameStringByValue((int64)Value);
}
```

This can be used to read all the names of an enum's possible values, for example to populate a combo box.
I think this only works for consecutive 0 to N-1 enums, i.e., no fancy `=` in the enum definition.
```cpp
TArray<TSharedPtr<FString>> ComboBoxEntries;
UEnum* MyEnum = StaticEnum<EMyEnum>();
check(MyEnum);
for (int32 EnumIndex = 0; EnumIndex < MyEnum->NumEnums() - 1; ++EnumIndex)
{
    ComboBoxEntries.Add(
        MakeShareable(new FString(MyEnum->GetNameStringByIndex(EnumIndex))));
}
```

Not sure why it does `-1` in the `for`-loop.

`FindObject<UEnum>;` is the old way to do `StaticEnum`.
Don't know why it was replaced, or when.


## Creating new enums

An enum can be either scoped or unscoped.
A scoped enum is also called a class enum.
A scoped enum places its enum literals in a separate scope.

```cpp
UENUM(BlueprintType)
enum EMyUnscopedEnum : uint8
{
    FirstMember,
    SecondMember
};

UENUM(BlueprintType)
enum class EMyScopedEnum : uint8
{
    FirstMember,
    SecondMember
};

void Demo()
{
    std::cout << "Accessing an unscoped enum: " << FirstMember;
    std::cout << "Accessing a scoped enum: " << EMyScopedEnum::FirstMember;
}
```
We can add meta-data to our enum literals:
```cpp
UENUM(BlueprintType)
enum class EMyScopedEnum : uint8
{
    FirstMember UMETA(DisplayName="First member"),
    SecondMember UMETA(DisplayName="Second member")
};
```


## Enum UPROPERTIES

An enum can be a UPROPERTY on a U-class.
Unscoped enum must be wrapped in a `TEnumAsByte<E>`.
Therefore, prefer scoped enums, i.e., `UENUM(BlueprintType) enum class EMyScopedEnum : uint8 {}`.

```cpp
UCLASS()
class UMyClass : public UObject
{
    GENERATED_BODY()

    UPROPERTY()
    TEnumAsByte<EMyUnscopedEnum> MyUnscopedEnumBad;

    UPROPERTY()
    EMyScopedEnum MyScopedEnumGood;
}
```

[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)   

