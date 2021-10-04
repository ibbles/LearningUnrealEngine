2021-09-17_16:07:24

# Hash

Unreal Engine uses hashes for various things, such as `TMap`.
The following is an example of how to add a hash function to a type.
A template parameter pack version of `HasCombine` + `GetTypeHash` seems like a natural extension.

```cpp
class FVertex
{
    FVector Position;
    FVector Normal;
    FVector2D UV;
    FVector4 Colors;

    friend uint32 GetTypeHash(const FVertex& Key)
    {
        return
            HashCombine(
                GetTypeHash(Key.Position),
                HashCombine(
                    GetTypeHash(Key.Normal),
                    HashCombine(
                        GetTypeHash(Key.UV),
                        GetTypeHash(Key.Colors))));
        }
};
```

The following is untested but should get the idea across.
```cpp
// Base case.
template <typename TLast>
uint32 HashAndCombine(TLast Last)
{
    return GetTypeHash(Last);
}

// Recursive case.
template <typename THead, typename... TTail>
uint32 HashAndCombine(THead Head, TTail... Tail)
{
    return HashCombine(GetTypeHash(Head), HashAndCombine(Tail...));
}
```