2021-04-03_18:13:02

# Adding icon/sprite to Component

All Scene Component subclasses has the option to get an icon representation in the Editor Viewport.
This makes it possible too see and identify the Component even if it doesn't have an inherent visual representation.
The icon is an editor-only feature and all related code should be guarded by a `#if WITH_EDITORONLY_DATA`.

To request an icon set the `bVisualizeComponent` member variable to `true` in the constructor.
This member variable is checked in `USceneComponent::OnRegister` and if `true` a Billboard Component is created.

`MyComponent.h`:
```cpp
#pragma once
#include "Component/SceneComponent.h"

UCLASS()
class MYMODULE_API UMyComponent : public USceneComponent
{
    GENERATED_BODY()
public:
    UMyComponent();
};
```

`MyComponent.cpp`:
```cpp
#include "MyComponent.h"

UMyComponent::UMyComponent()
{
#if  WITH_EDITORONLY_DATA
    bVisualizeComponent = true;
#endif
}
```

By default the Component will get a white sphere icon.
If we want another icon we can change it after the base class has created the default one.
This can be done after the call to the `Super` implementation of `OnRegister`.

`MyComponent.h`:
```cpp
#pragma once
#include "Component/SceneComponent.h"

UCLASS()
class MYMODULE_API UMyComponent : public USceneComponent
{
    GENERATED_BODY()

public:
    UMyComponent();

    //~ Begin ActorComponent Interface.
    virtual void OnRegister() override;
    //~ End ActorComponent Interface.
}
```

The Sprite Component is in fact a Billboard Component so we need that header file.
After `Super::OnRegister();` we call `SetSprite` on the Sprite Component and pass in a texture that we load.

`MyComponent.cpp`:
```cpp
#include "MyComponent.h"
#include "Components/BillboardComponent.h"

UMyComponent::UMyComponent()
{
#if  WITH_EDITORONLY_DATA
    bVisualizeComponent = true;
#endif
}

void UMyComponent::OnRegister()
{
    Super::OnRegister();
#if  WITH_EDITORONLY_DATA
    if (SpriteComponent)
	{
		SpriteComponent->SetSprite(LoadObject<UTexture2D>(
            nullptr, TEXT("/Game/EditorResources/Icons/S_MyIcon.S_MyIcon")));
	}
#endif
}
```

An alternative way is to load the texture once with a static local variable in the constructor and then reuse it for all instances of that Component type.

`MyComponent.h`:
```cpp
#pragma once
#include "Component/SceneComponent.h"

UCLASS()
class MYMODULE_API UMyComponent : public USceneComponent
{
    GENERATED_BODY()

public:
    UMyComponent();

    //~ Begin ActorComponent Interface.
    virtual void OnRegister() override;
    //~ End ActorComponent Interface.
    
private:
#if WITH_EDITORONLY_DATA
	UPROPERTY(Transient)
	UTexture2D* EditorSpriteTexture;
#endif
}
```

`MyComponent.cpp`:
```cpp
UMyComponent::UMyComponent()
{
#if WITH_EDITORONLY_DATA
    bVisualizeComponent = true;
    if (!IsRunningCommandlet())
    {
        static ConstructorHelpers::FObjectFinder<UTexture2D> StaticTexture(
            TEXT("/Game/EditorResources/Icons/S_MyIcon"));
        EditorSpriteTexture = StaticTexture.Object;
    }
#endif
}

void UMyComponent::OnRegister()
{
    Super::OnRegister();
#if  WITH_EDITORONLY_DATA
    if (SpriteComponent)
	{
		SpriteComponent->SetSprite(EditorSpriteTexture);
	}
#endif
}
```

I don't know why the the first version repeats the asset name in the path while the second version don't.
Also don't know why the second version checks `IsRunningCommandlet()` while the first version don't.
The first version is based on [`AudioComponent`](https://github.com/EpicGames/UnrealEngine/blob/4.25.3-release/Engine/Source/Runtime/Engine/Private/Components/AudioComponent.cpp#L862).
The second version is based on (`CameraShakeSourceComponent`)[https://github.com/EpicGames/UnrealEngine/blob/4.25.3-release/Engine/Source/Runtime/Engine/Private/Camera/CameraShakeSourceComponent.cpp#L47].

[[Adding icon to Actor]] [Adding icon to Actor](./Adding%20icon%20to%20Actor.md)  

