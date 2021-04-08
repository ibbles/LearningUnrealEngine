2020-08-06_18:48:41

# Component Visualizer

Component Visualizers are a way to render Components outside of the regular rendering pipeline.
Often used for things that have no inherent visual representation, such as an audio source.
Can also provide interactivity to the Component through Hit Proxies and Context Menus.
Are Editor only, and must be in an Editor module.

## Rendering

Create a new class in an Editor Module inheriting from `FComponentVisualizer`.

[[2021-02-19_08:26:26]] [Editor module](Editor%20module.md)

`MyComponentVisualizer.h`:
```cpp
#pragma once
#include "ComponentVisualizer.h"

class MYEDITORMODULE_API FMyComponentVisualizer : public FComponentVisualizer
{
};
```

Register the visualizer in the project's editor module's `StartModule` function using the the name of the Component class we wish to use the new Component Visualizer for:

`MyModule.cpp`:
```c++
void FMyEditorModule::StartupModule()
{
    GUnrealEd->RegisterComponentVisualizer(
        UMyComponent::StaticClass()->GetFName(),
        MakeShareable(new FMyComponentVisualizer()));
}
```

When Unreal Editor has determined that a Component is to be visualized it calls the `DrawVisualization` member function on the Component Visualizer which has been registered with the Component's name.

`MyComponentVisualizer.h`:
```cpp
#pragma once
#include "ComponentVisualizer.h"

class MYEDITORMODULE_API FMyComponentVisualizer : public FComponentVisualizer
{
public:
    //~ Begin FComponentVisualizer Interface
	virtual void DrawVisualization(
		const UActorComponent* Component, const FSceneView* View,
		FPrimitiveDrawInterface* PDI) override;
    //~ End FComponentVisualizer Interface
};
```

The `UActorComponent` passed is the Component to be rendered.
It will be of the type the Component Visualizer was registered for.
`FSceneView` is a camera-like class that provides information on things such as the view location, the field of view, and right- and up vectors.
`FPrimitiveDrawInterface` is used to draw points, lines, and sprites.
It might be able to draw meshes as well, not sure how to do that.

Example drawing a line from the Component's location and one meter along the forward direction:

`MyComponentVisualizer.cpp`:
```cpp
#include "MyComponentVisualizer.h"
#include "MyComponent.h"
#include "SceneManagement.h"

void FMyComponentVisualizer::DrawVisualization(
    const UActorComponent* Component,
    const FSceneView* View,
    FPrimitiveDrawInterface* PDI)
{
    const UMyComponent* MyComponent = Cast<UMyComponent>(Component);
    if (MyComponent == nullptr)
    {
        return;
    }
    const FVector LineStart = MyComponent->GetComponentLocation();
    const FVector LineEnd = LineStart + MyComponent->GetForwardVector() * 100.0f;
    const FLinearColor Color = FLinearColor::Red;
    const ESceneDepthPriorityGroup DepthGroup = ESceneDepthPriorityGroup::SDPG_Foreground;
    PDI->DrawLine(LineStart, LineEnd, Color, DepthGroup);
}
```

The depth priority group can be either `SDPG_Foreground` or `SDPG_World`.
The depth priority group is a priority for sorting scene elements by depth. Elements with higher priority occlude elements with lower priority, disregarding distance. Foreground has higher priority than World.

`SceneManagement.h` contains a bunch of free functions that use the basic drawing functions provided by the `FPrimitiveDrawInterface` to draw more complicated shapes.
Example drawing a circle around the Component's location. It uses the `FSceneView` to orient the circle towards the camera.

`MyComponentVisualizer.cpp`:
```cpp
void FMyComponentVisualizer::DrawVisualization(
    const UActorComponent* Component,
    const FSceneView* View,
    FPrimitiveDrawInterface* PDI)
{
    const FVector Center = Component->GetComponentLocation();
    const FVector PlaneTangentX = View->GetViewRight();
    const FVector PlaneTangentY = View->GetViewUp();
    const FLinearColor Color = FLinearColor::Red();
    const Radius = 100.0f;
    const int32 NumSegments = 32;
    const uint8 DepthPriority = SDPG_Foreground;
    DrawCircle(
        PDI, Center, PlaneTangentX, PlaneTangentY,
        Color, Radius, NumSegments, DepthPriority);
}
```

## Interactivity

A Component Visualizer can be used to create in-editor tools with interactable widgets.
The widgets can be selectable and movable.
Can set it up so dragging the default transform widget on the Component runs custom code within the visualizer.
Can also add context menus to the widgets.
The spline component visualizer code in the engine uses several of these features.

### Hit Proxies

The basis for interactive Component Visualizers is the Hit Proxy, or `HComponentVisProxy`, as it's called in C++.
We should create classes inheriting from `HComponentVisProxy` for each type of clickable widget we have.
Each drawing command on the `FPrimitiveDrawInterface` can be associated with a Hit Proxy.
When the drawn element is clicked the Hit Proxy is passed to `FComponentVisualizer::VisProxyHandleClick`.
The Hit Proxy class names are prefixed with `H`. Not sure why, not part of the Coding Standard Naming Conventions.

`MyComponentVisualizer.cpp`:
```cpp
struct HMyComponentProxy : public HComponentVisProxy
{
    DECLARE_HIT_PROXY();
    
    HMyComponentProxy(const UActorComponent* InComponent)
        : HComponentVisProxy(InComponent, HPP_Wireframe)
    {
    }
};

IMPLEMENT_HIT_PROXY(HMyComponentProxy, HComponentVisProxy);
```

The `DECLARY_HIT_PROXY();` line is similar to the `GENERATED_BODY();` line for U-classes, it's needed to make the Hit Proxy work.
`InComponent` is the Actor Component that the Hit Proxy is associated with, the Component that was visualized when the Hit Proxy was created.
`HPP_Wireframe` is similar to `SDPG_Foreground` in that it is a priority.
If multiple Hit Proxies are close to the click location then the on with the highest priority is chosen.
The priorities, from highest to lowest, are: `HPP_UI`, `HPP_Foreground`, `HPP_Wireframe`, and `HPP_World`.
`IMPLEMENT_HIT_PRXY` is another of those "just write it" kind of lines.
Pass your Hit Proxy type as the first parameter and that class' parent class as the second parameter.

Tutorials that include multiple Hit Proxy types often create one base class for that Visualizers' all Hit Box types.
I don't know why.

To add a Hit Proxy to our circle we call `FPrimitiveDrawInterface::SetHitProxy` before and after the `Draw` call.
On the first call pass in a new Hit Proxy instance. This Hit Proxy will be enabled for everything drawn until we set another Hit Proxy.
Always set the Hit Proxy to `nullptr` when all drawing that should have that Hit Proxy has been completed.

`MyComponentVisualizer.cpp`:
```cpp
void FMyComponentVisualizer::DrawVisualization(
    const UActorComponent* Component,
    const FSceneView* View,
    FPrimitiveDrawInterface* PDI)
{
    const FVector Center = Component->GetComponentLocation();
    const FVector PlaneTangentX = View->GetViewRight();
    const FVector PlaneTangentY = View->GetViewUp();
    const FLinearColor Color = FLinearColor::Red();
    const Radius = 100.0f;
    const int32 NumSegments = 32;
    const uint8 DepthPriority = SDPG_Foreground;
    
    PDI->SetHitProxy(new HMyComponentProxy(Component));
    DrawCircle(
        PDI, Center, PlaneTangentX, PlaneTangentY,
        Color, Radius, NumSegments, DepthPriority);
    // Any additional Draw call here will use the same Hit Proxy.
    PDI->SetHitProxy(nullptr);
}
```

### Listening for clicks

The `FComponentVisualizer` has a bunch of virtual member functions that are called when the user interacts with the Hit Proxy.
Regular clicks are sent to `VisProxyHandleClick`.

`MyComponentVisualizer.h`:
```cpp
#pragma once
#include "ComponentVisualizer.h"

class MYEDITORMODULE_API FMyComponentVisualizer : public FComponentVisualizer
{
public:
    //~ Begin FComponentVisualizer Interface
    
	virtual void DrawVisualization(
		const UActorComponent* Component, const FSceneView* View,
		FPrimitiveDrawInterface* PDI) override;
        
    virtual bool VisProxyHandleClick(
		FEditorViewportClient* InViewportClient, HComponentVisProxy* VisProxy,
		const FViewportClick& Click) override;
    
    //~ End FComponentVisualizer Interface
};
```

`MyComponentVisualizer.cpp`:
```cpp
bool FMyComponentVisualizer::VisProxyHandleClick(
	FEditorViewportClient* InViewportClient, HComponentVisProxy* VisProxy,
	const FViewportClick& Click)
{
	return true;
}
```

A common use case for clicks is selection.
If our Component contains a bunch of internal objects we may want to visualize them and select one for editing.
We do that by associating a Hit Proxy with each object and storing the object's index in the Hit Proxy.
In the following, assume that `UMyComponent` has a `TArray<FVector> ObjectLocations`.

`MyComponentVisualizer.h`:
```cpp
#pragma once
#include "ComponentVisualizer.h"

/**
 * Component Visualizer for UMyComponent. Handles rendering sub-objects as
 * points and single subobject selection.
 */
class MYEDITORMODULE_API FMyComponentVisualizer : public FComponentVisualizer
{
public:
    /** Called when a UMyComponent is to be visualized. */
    virtual void DrawVisualization(
		const UActorComponent* Component, const FSceneView* View,
		FPrimitiveDrawInterface* PDI) override;

    /** Called when one of this Component Visualizer's Hit Proxies is clicked. */
	virtual bool VisProxyHandleClick(
		FEditorViewportClient* InViewportClient, HComponentVisProxy* VisProxy,
		const FViewportClick& Click) override;

private:
    // The currently selected sub-object. Can be INDEX_NONE.
    int32 SelectedObjectIndex = INDEX_NONE;
};
```

`MyComponentVisualizer.cpp`:
```cpp
#include "MyComponentVisualizer.h"
#include "MyComponent.h"

/**
 * Hit Proxy that handles selection. There is one instance of this class
 * per sub-object and the Hit Proxy carries the index of the sub-object it
 * belongs to.
 */
class HMySelectProxy : public HComponentVisProxy
{
    DECLARE_HIT_PROXY();
    
    HMySelectProxy(const UMyComponent* InComponent, int32 InObjectIndex)
        : HComponentVisProxy(InComponent, HPP_Wireframe)
        , ObjectIndex(InObjectIndex)
    {
    }
    
    int32 ObjectIndex;
};

IMPLEMENT_HIT_PROXY(HMySelectProxy, HComponentVisProxy);

void FMyComponentVisualizer::DrawVisualization(
    const UActorComponent* Component,
    const FSceneView* View,
    FPrimitiveDrawInterface* PDI)
{
    // Only draw if we have a valid UMyComponent.
    const UMyComponent* MyComponent = Cast<UMyComponent*>(Component);
    if (MyComponent == nullptr)
    {
        return;
    }
    
    // Some settings. These can be made properties of UMyComponent, to
    // provide improved customization for the user.
    const float ObjectSize = 10.0f;
    const FLinearColor ObjectColor = FLinearColor::White;
    const FLinearColor SelectedColor = FLinearColor::Ref;
    
    // Draw each sub-object.
    for (int32 I = 0; I < MyComponent->ObjectLocations.Num(); ++I)
    {
        // Draw each sub-object as a point, with a different color for
        // the selected one, if any. A Hit Proxy is regested before each
        // draw call, passing in the index of the current sub-object.
        PDI->SetHitProxy(new HMySelectProxy(MyComponent, I));
        PDI->DrawPoint(
            MyComponent->ObjectLocations[I],
            I == SelectedObject ? SelectedColor : ObjectColor,
            ObjectSize,
            SDPG_Foreground);
        // Reset the Hit Proxy afterwards so we don't accidentally register the
        // HMySelectProxy with some unrelated drawing we might add later.
        PDI->SetHitProxy(nullptr);
    }
}

bool FMyComponentVisualizer::VisProxyHandleClick(
    FEditorViewportClient* InViewportClient,
    HComponentVisProyx* VisProxy,
    const FViewportClick& Click)
{
    // Only accept the click if the VisProxy has a valid Component.
    if (!VisProxy->Component->IsValid())
    {
        return false;
    }
    
    // Check if the Hit Proxy is one of the types that we care about. There
    // may be many chained 'else if' tests here.
    if (HMySelectProxy* SelectProxy = HitProxyCast<HMySelectProxy>(VisProxy))
    {
        // Determine if we clicked on the same sub-object as last time, or a
        // new one.
        if (SelectProxy->ObjectIndex == SelectedObjectIndex)
        {
            // If the selected object is clicked then it is deselected by setting
            // the selection index to INDEX_NONE.
            SelectedObjectIndex = INDEX_NONE;
        }
        else
        {
            // If an unselected object is clicked then it becomes the selected object.
            SelectedObjectIndex = SelectProxy->ObjectIndex;
        }
        // We did handle the click, so return true.
        return true;
    }
    // Can add additional 'if (HMyProxyType* MyProxyType = ...)' tests here.
    else
    {
        // We did not handle the click, so return false.
        return false;
    }
}
```

### Object location manipulation



[[2020-12-03_10:41:49]] [Editor mode](./Editor%20mode.md)  
[[2021-02-19_08:26:26]] [Editor module](./Editor%20module.md)  

[Component Visualizers @ ue4community.wiki](https://www.ue4community.wiki/legacy/component-visualizers-xaa1qsng)  
[Coding Standard - Naming Conventions @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProductionPipelines/DevelopmentSetup/CodingStandard/index.html#namingconventions)  