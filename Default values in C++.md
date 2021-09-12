2021-08-24_17:25:10

# Default values in C++

UProperties set during object construction becomes read-only / grayed out / disabled in the Details Panel.
This includes both the Blueprint Construction Visual Script and the `PostInitProperties` C++ virtual member function. I'm unsure if the C++ constructor has this problem or not.

We can disable this feature by adding the `SkipICSModifiedProperties` Meta Specifier to the UProperty

```cpp
UPROPERTY(EditAnywhere, Meta = (SkipUCSModifiedProperties))
int32 MyProperty;
```

Not sure how this works when the UProperty is inside a struct.
Should Skip UCS Modified Properties be added on the leaf UProperty (inside the struct) or the root UProperty (the top-most UObject in the enclosing chain), or on everything in between as well?