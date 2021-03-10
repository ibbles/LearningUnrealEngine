2021-03-10_12:51:35

# Slate and casting

Many Unreal Engine builds disable Runtime Type Information (RTTI), which disables `dynamic_cast` of pointers.
Unreal Engine provides `Cast` instead, which uses the reflection system to validate the cast.
`Cast` only work on `UObject` pointer types and the Slate widgets are not `UObject`s.
We can use `static_cast` to cast our Slate widget pointer.
`static_cast` is only valid if we're sure that the pointed-to object really is of the target type.
We can check the type of a Slate widget using `FName SWidget::GetType()`.

An example:

```cpp
template<typename T>
T* CastSlate(SWidget* Widget, FName TypeName)
{
    if (Widget->GetType() != "TypeName")
    {
        return nullptr;
    }
    return static_cast<T*>(Widget);
}
```

Example usage:
```cpp
void MyFunction(SWidget* Widget)
{
    if (SButton* Button = CastSlate<SButton>("SButton"))
    {
        // Do something with a button.
    }
    else if (SWindow* Window = CastSlate<SWindow>("SWindow"))
    {
        // Do something with a window.
    }
}
```

I don't see how this can work with deeper inheritance hierarchies though.
I suspect you need to test for the exact type, not an inherited type.
Maybe something can be done with `SWidget::GetMetaData`.
I also don't understand how this works with `SWindow` since it has `EWindowType GetType()`.
I expect that to shadow the `FName`-returning `GetType()`.
Try with `MyWidget->SWidget::GetType()` if you have a `SWindow*`.

I haven't been able to find a `GetStaticType` or similar.
If there is one then one can remove the `FName` parameter:
```cpp
template<typename T>
T* CastSlate(SWidget* Widget)
{
    if (Widget->GetType() != T::GetStaticType()) // Is there a GetStaticType?
    {
        return nullptr;
    }
    return static_cast<T*>(Widget);
}
```



[SWidget::GetType @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/API/Runtime/SlateCore/Widgets/SWidget/GetType/index.html)  
[Casting slate widgets @ answers.unrealengine.com](https://answers.unrealengine.com/questions/214303/casting-slate-widgets.html)  