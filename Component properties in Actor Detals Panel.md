2020-12-31_15:03:39

# Component properties in Actor Details Panel

Sometimes the properties of a Component show up when the owning Actor is selected in the World Outliner.
I'm trying to understand when this happen, and how to make it happen.

## C++ Actor with `UPROPERTY` Component as root component.

This shows the `UStaticMeshComponent` properties in the Actor's Details Panel.

Header:
```cpp
#pragma once

#include "GameFramework/Actor.h"

class UStaticMeshComponent;

UCLASS()
class AMyActor : public AActor
{
public:
    GENERATED_BODY()
    
    AMyActor();
    
    UPROPERTY(VisibleAnywhere)
    UStaticMeshComponent* Mesh;
}
```

Implementation:
```ccpp
#include "MyActor.h"

AMyActor::AMyActor()
{
    Mesh = CreateDefaultSubobject(TEXT("MyMesh"));
    SetRootComponent(Mesh);
}
```