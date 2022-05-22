2022-02-01_17:30:54

# Changing the type of a Property

Instead of [[2022-02-01_17:30:59]] [Deprecating UProperties](./Deprecating%20UProperties.md) one can change the type of it.
This only works when changing the type to a `struct`, to to a primitive type.

As an example, consider the following class:
```cpp
UCLASS()
class MYMODULE_API UMyClass : public UObject
{
public:
    UPROPERTY()
    float MyProperty;
};
```

Now we want `MyProperty` to be an `FMyStruct` instead.
```cpp
USTRUCT()
struct MYMODULE_API FMyStruct
{
    float Data;
};


UCLASS()
class MYMODULE_API UMyClass : public UObject
{
public:
    UPROPERTY()
    FMyStruct MyProperty;
};

```

To maintain backwards compatibility we need to handle this change in the serialization.


## Deprecate the old Property and create a new one

The simplest way is to deprecate the old Property and create a new one using the struct.
For details on this technique see [[2022-02-01_17:30:59]] [Deprecating UProperties](./Deprecating%20UProperties.md).
```cpp
UCLASS()
class MYMODULE_API UMyClass : public UObject
{
public:
    UPROPERTY()
    FMyStruct MyPropertyNew
    
    // ~Begin UObject interface.
    virtual Serialize(FArchive& Archive);
    // ~End UObject interface.
private:
    UPROPERTY()
    float MyProperty_DEPRECATED;
};

```

The drawback of this approach is that now we have a new name for the user-facing Property.

## Serialize from mismatched tag

If we want to keep the same name of the Property then we must handle serialization of mismatched tags.
"Mismatched tags" means that the archive we are reading from has stored another type for the Property than we are currently reading into.
We cannot do this in the `Serialize` member function only because engine code earlier than that will detect the mismatch.
So we must set up a type conversion for the struct.

Notice that it is the struct that handles the conversion, not the class that used to have a `float` and how has a struct instead.

First we tell Unreal that we want to handle mismatched tags for our new struct.
```cpp
#include "UObject/Class.h"

// The struct definition goes here.

template<>
struct TStructOpsTypeTraits<FMyStruct> : public TStructOpsTypeTraitsBase2<FMyStruct>
{
	enum
	{
		WithStructuredSerializeFromMismatchedTag = true,
	};
};
```

The enum in `TStructOpsTypeTraits<FMyStruct>` can contain a number of members, here we only need the one.
(
I assume not specifying the others will leave them at their default.
)

Having requested serialize from mismatched tag we also need to provide that functionality in our struct.
```cpp
USTRUCT()
struct MYMODULE_API FMyStruct
{
    float Data;
    
    bool SerializeFromMismatchedTag(
        struct FPropertyTag const& Tag,
        FStructuredArchive::FSlot Slot);
};
```

`Tag` is the type tag of the data in the archive being read and `Slot` is a way of getting at that data.

In the implementation of `SerializeFromMismatchedTag` we read from the slot and write to the struct member.
```cpp
bool FMyStruct::SerializeFromMismatchedTag(
    struct FPropertyTag const& Tag,
    FStructuredArchive::FSlot Slot)
{
    if (Tag.Type == NAME_FloatProperty)
    {
        float OldValue;
		Slot << OldValue;
        // Do any kind of conversion you might need here.
        Data = OldValue;
        return true;
    }
    else
    {
        return false;
    }
}
```



So the complete code becomes.

`MyStruct.h`:
```cpp
#include "UObject/Class.h"
#include "MyStruct.generated.h"

USTRUCT()
struct MYMODULE_API FMyStruct
{
    float Data;
    
    bool SerializeFromMismatchedTag(
        struct FPropertyTag const& Tag,
        FStructuredArchive::FSlot Slot);
};

template<>
struct TStructOpsTypeTraits<FMyStruct> : public TStructOpsTypeTraitsBase2<FMyStruct>
{
	enum
	{
		WithStructuredSerializeFromMismatchedTag = true,
	};
};
```

`MyStruct.cpp`:
```cpp
bool FMyStruct::SerializeFromMismatchedTag(
    struct FPropertyTag const& Tag,
    FStructuredArchive::FSlot Slot)
{
    if (Tag.Type == NAME_FloatProperty)
    {
        float OldValue;
		Slot << OldValue;
        // Do any kind of conversion you might need here.
        Data = OldValue;
        return true;
    }
    else
    {
        return false;
    }
}
```

`MyClass.h`:
```cpp
UCLASS()
class MYMODULE_API UMyClass : public UObject
{
public:
    // Used to be a float, is now FMyStruct and is automatically
    // converted on load of old assets.
    UPROPERTY()
    FMyStruct MyProperty;
};
```


I learned about this from [`FKey`](https://github.com/EpicGames/UnrealEngine/blob/4.25/Engine/Source/Runtime/InputCore/Classes/InputCoreTypes.h#L41), [`FNiagaraMeshMaterialOverride`](https://github.com/EpicGames/UnrealEngine/blob/4.25/Engine/Plugins/FX/Niagara/Source/Niagara/Public/NiagaraMeshRendererProperties.h#L41), and [`AttributeSet`](https://github.com/EpicGames/UnrealEngine/blob/4.25/Engine/Plugins/Runtime/GameplayAbilities/Source/GameplayAbilities/Private/AttributeSet.cpp#L482).