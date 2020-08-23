2020-07-02_15:45:39

# Enum

An enum is a compile-time list of named elements.
Each element is an integer, starting from 0 and counting up.
The number of elements is returned by the `Get number of entries in <ENUM>` node.
Select a random enum element with `Random Integer in Range` and `Get number of entries in <ENUM>` - 1, convert the random Integer to Byte, then finally `Literal enum <ENUM>`.
Enums elements can be converted to String. 


Enums can be printed in C++ with:

```c++
StaticEnum<EMyEnum>()->GetNameByValue( EMyEnum::Value )
```
Or
```c++
GetDisplayNameTextByValue()
```
`StaticEnum<EMyEnum>()` returns a `UEnum*`.

May need `GetNameByValue(int64(SomeEnumValue))`.

A helper:
```c++
template<typename T>
static FString EnumToString(const T Value)
{
	return StaticEnum<T>()->GetNameStringByValue((int64)Value);
}
```

`FindObject<UEnum>;` is the old way to do it.
