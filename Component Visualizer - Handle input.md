2021-08-26_12:32:42

# Component Visualizer - Handle input

There is `HandleInputDelta` and `HandleInputKey`.
When you have determined that a change is going to happen (all checks passed) then call `Modify` on the edited object, do the change, and then call `NotifyPropertyModified` and `GEditor->RedrawLevelEditingViewports`.

```cpp
bool FMyVisualizer::HandleInputDelta(
    FEditorViewportClient* ViewportClient,
    FViewport* Viewport,
    FVector& DeltaTranslate,
    FRotator& DeltaRotate,
    FVector& DeltaScale)
{
    UMyComponent* My = GetSelectedMy();
    if (My == nullptr)
    {
        return false;
    }
    if (DeltaTranslate.IsZero())
    {
        return true;
    }
    My->Modify();
    My->MyProperty += DeltaRotate;
    NotifyPropertyModified(
        My,
        FindFProperty<FProperty>(
            Class, GET_MEMBER_NAME_CHECKED(UMyComponent, MyProperty)
        )
    );
    GEditor->RedrawLevelEditingViewports()
}
```

Getting the edited Component is complicated.
The strategy I've seen uses Hit Proxies that store a pointer to the Component and a Hit Proxy callback on the Visualizer that read that pointer and remembers it for use in `HandleInputDelta`.

[[2020-08-06_18:48:41]] [Component visualizer](./Component%20visualizer.md)  
