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

    /** Called when the visualized Component is deselected. */
    virtual void EndEditing() override;

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

void FMyComponentVisualizer::EndEditing()
{
	SelectedObjectIndex = INDEX_NONE;
}
```

### Object location manipulation

Sub-objects are made movable by implementing two virtual member functions.
The first, `GetWidgetLocation`, tell Unreal Editor where to render the object manipulation widget.
The second, `HandleInputDelta`, is called when the object manipulation widget is moved by the user.
In order to access the selected Component from these member functions we need to store a pointer to it in the click callback.

(
I'm not sure how to best handle storing a pointer to the selected Component.
We need to be able to manipulate the Component in `HandleInputDelta` so it must be a non-`const` pointer.
But the only place we're given access to the Component is in `VisProxyHandleClick` through the Hit Proxy, which has a `const` pointer to the Component.
Here I hack it with a `const_cast` but I assume there is a better solution.
`FSplineComponentVisualizer` uses a `FComponentPropertyPath` to store the Component, in 4.25.
In 4.26 water splines was added and the `FComponentProperty` path was moved to a shared `USplineComponentVisualizerSelectionState`.
But it's still there.
)

This code example builds on the one from the previous subsection.

`MyComponentVisualizer.h`:
```cpp
#pragma once
#include "ComponentVisualizer.h"

class UMyComponent;

class MYEDITORMODULE_API FMyComponentVisualizer : public FComponentVisualizer
{
public:
    /** Called when one of this Component Visualizer's Hit Proxies is clicked. */
	virtual bool VisProxyHandleClick(
		FEditorViewportClient* InViewportClient,
        HComponentVisProxy* VisProxy,
		const FViewportClick& Click) override;

    /** Called when Unreal Editor is about to render the object manipulation widget. */
    virtual bool GetWidgetLocation(
		const FEditorViewportClient* ViewportClient,
        FVector& OutLocation) const override;

    /** Called when the user has interacted with the object manipulation widget. */
	virtual bool HandleInputDelta(
		FEditorViewportClient* ViewportClient,
        FViewport* Viewport,
        FVector& DeltaTranslate,
		FRotator& DeltaRotate,
        FVector& DeltaScale) override;

private:
    /** The currently selected sub-object. Can be INDEX_NONE. */
    int32 SelectedObjectIndex = INDEX_NONE;

    /**
     * The UMyComponent that was most recently draw, i.e., the UMyComponent for
     * which we have active Hit Proxes.
     */
    UMyComponent* SelectedMyComponent;
};
```

`MyComponentVisualizer.cpp`:
```cpp
#include "MyComponentVisualizer.h"
#include "MyComponent.h"

#include "Editor.h"

bool FMyComponentVisualizer::VisProxyHandleClick(
    FEditorViewportClient* InViewportClient,
    HComponentVisProyx* VisProxy,
    const FViewportClick& Click)
{
    // Only accept the click if the VisProxy has a valid Component.
    const UMyComponent* MyComponent = Cast<const UMyComponent(VisProxy->Component);
    if (MyComponent == nullptr)
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
            SelectedMyComponent = nullptr;
        }
        else
        {
            // If an unselected object is clicked then it becomes the selected object.
            /// \todo Remove const_cast and instead use a FComponentPropertyPath to
            /// store the Component.
            SelectedObjectIndex = SelectProxy->ObjectIndex;
            SelectedMyComponent = const_cast<UMyComponent*>(MyComponent);
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

/**
 * Assign the location of the currently selected sub-object, if any, to OutLocation.
 */
bool FMyComponentVisualizer::GetWidgetLocation(
	const FEditorViewportClient* ViewportClient,
    FVector& OutLocation) const
{
    // We can only find the sub-object location if we have access to the actual Component.
	if (SelectedMyComponent == nullptr)
	{
		return false;
	}
    // We can only find the sub-object location if we have a valid sub-object index.
	if (!SelectedMyComponent->ObjectLocations.IsValidIndex(SelectedObjectIndex))
	{
		return false;
	}

    // Tell Unreal Editor where we would like to place the object manipulation widget.
    OutLocation = SelectedMyComponent->ObjectLocations[SelectedObjectIndex];
	return true;
}

/**
 * Move the selected sub-object, if any, according to DeltaTranslate.
 */
bool FMyComponentVisualizer::HandleInputDelta(
	FEditorViewportClient* ViewportClient,
    FViewport* Viewport,
    FVector& DeltaTranslate,
	FRotator& DeltaRotate,
    FVector& DeltaScale)
{
    // We can only move the sub-object if we have access to the actual Component.
	if (SelectedMyComponent == nullptr)
	{
		return false;
	}
    // Don't try to move anything if no sub-object is selected.
	if (SelectedObjectIndex == INDEX_NONE)
	{
		return false;
	}
    // Reset the selection if it has become invalid for some reason.
    // The user must click a Hit Proxy again to produce a new selection.
	if (!SelectedMyComponent->ObjectLocations.IsValidIndex(SelectedObjectIndex))
	{
		SelectedObjectIndex = INDEX_NONE;
		SelectedMyComponent = nullptr;
		return false;
	}

    // No need to do anything if the translation is zero. However, since we could
    // have done an actual move we still return true.
	if (DeltaTranslate.IsZero())
	{
		return true;
	}

    // Mark the Component as modified, for the undo history.
	SelectedMyComponent->Modify();

    // Do the actual move.
    SelectedMyComponent->ObjectLocations[SelectedObjectIndex] + DeltaTranslate;

    // Request a redraw with the new sub-object location.
	GEditor->RedrawLevelEditingViewports();

	return true;
}
```

[[2020-12-03_10:41:49]] [Editor mode](./Editor%20mode.md)  
[[2021-02-19_08:26:26]] [Editor module](./Editor%20module.md)  

[Component Visualizers @ ue4community.wiki](https://www.ue4community.wiki/legacy/component-visualizers-xaa1qsng)  
[Coding Standard - Naming Conventions @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProductionPipelines/DevelopmentSetup/CodingStandard/index.html#namingconventions)  