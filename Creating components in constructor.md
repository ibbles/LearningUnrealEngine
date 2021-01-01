2020-11-30_10:36:27

# Creating components in constructor

An Actor's Components are often created in the Actor's constructor.
Create such components with `CreateDefaultSubobject`.
Only components created in an Actor's constructor with `CreateDefaultSubobject` will show up in the Blueprint Editor.
(I think.)
The function may only be called in the constructor of the owning object.
It is a template function, with the type parameter being the the type to instantiate.
It takes (at least?) one parameter, which is the label/name of the created object.
The member variable that the return value of `CreateDefaultSubobject` is assigned to should generally be a `UPROPERTY`.

```cpp
MyProperty = CreateDefaultSubobject<UMyType>(TEXT("MyLabel"));
```

If the Component is a `USceneComponent`, or one of its subclasses, then it should be added to the Component hierarchy.
Make it the root with `SetRootComponent`.
Attach to another Component already in the hierarchy with `SetupAttachment`.
`SetupAttachment` can be passed a socket name, to attach the new component at that socket on the parent Component.

It is common to not configure a lot of details on the created components.
In particular, one rarely assign assets to e.g. meshes in C++.
It is better to assign assets in a Blueprint subclass of the C++ class, or in instance of the C++ class in the Level Editor.
Because asset references in C++ are clunky and cannot be automatically updated by Unreal Editor the way Blueprint references can.

Header:
```cpp
#pragma once

#include "GameFramework/Actor.h"

#include "MyActor.generated.h"

class UCamera;
class USpringArm;
class UStaticMeshComponent;


UCLASS()
class AMyActor : public AActor
{
    GENERATED_BODY()
    
public:
    UPROPERTY()
    UStaticMeshComponent* Mesh;
    
    UPROPERTY()
    USpringArmComponent* Arm;
    
    UPROPERTY()
    UCameraComponent* Camera;
};
```

Source:
```cpp
AMyActor::AMyActor()
{
    Mesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
    SetRootComponent(Mesh);
    
    Arm = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Arm"));
    Arm->SetupAttachment(Mesh);
    
    Camera = CreateDefaultSubobject<UCameraComponent>(TEXT("Camera"));
    Camera->SetupAttachment(Arm, USpringArmComponent::SocketName);
}
```

Always close Unreal Editor when compiling changes to constructors or header files.
Really, always close Unreal Editor when compiling.