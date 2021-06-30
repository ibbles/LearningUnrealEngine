2021-06-22_13:01:48

# Reflection system

Each UObject instance know what type it is.
It is exposed through a `UClass` instance.
The UClass knows what UProperties it contains.

The reflection system can be used to do casting from a generic base class to a more specific derived class.
The cast will succeed if the given object instance is of the given type, including subclasses.
```cpp
void CastExample(UMyBase* Base)
{
    UMyDerived* Derived = Cast<UMyDerived>(Base);
    if (Derived == nullptr)
    {
        // Cast failed, the passed object wasn't a UMyDerived instance.
    }

    // Cast succeeded, use Derived.
}
```

[[2020-10-03_10:52:02]] [UObject](./UObject.md)  
[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  