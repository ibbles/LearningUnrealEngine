2020-08-06_18:48:41

# Component Visualizer

Component Visualizers are
A Component Visualizer is something that knows how to render a specific type of Component.
Often used for things that have no inherent visual representation, such as an audio source.
Create a new class inheriting from `FComponentVisualizer`.
Register the visualizer in a module's `StartModule` (or whatever it's name is).
```c++
TSharedPtr<FHT_SeatExitVisualizer> SeatVisualizer =
    MakeShareable(new FHT_SeatExitVisualizer());
GUnrealEd->RegisterComponentVisualizer(
    UHT_SeatExitComponent::StaticClass()->GetFName(),
    SeatVisualizer);
```

A Component Visualizer can also be used to create in-editor tools with interactable widgets.
The widgets can be selectable and movable.
Can set it up so dragging the default transform widget on the actor (or component?) runs custom code within the visualizer.
See also [[Editor mode]] [Editor mode](./Editor mode.md). 

To learn how to do this read the spline component visualizer code in the engine.

[Component Visualizers @ ue4community.wiki](https://www.ue4community.wiki/legacy/component-visualizers-xaa1qsng)  