2020-10-19_11:22:12

# Niagara and C++

To use Niagara particle systems in C++ we need to link with the two Niagara modules.
Add `Niagra` and `NiagaraCore` to `PublicDependencyModuleNames` in the module's `.Build.cs`.
(
Why not `PrivateDependencyModuleNames`?
Try it.
)

There are two central classes: `UNiagaraSystem` and `UNiagaraComponent`.
A `UNiagaraSystem` is a reference to a Niagara System asset in the Content Browser.
A `UNiagaraComponent` is an instantiation of an `UNiagaraSystem` in the world.

## Spawning a particle system
A common workflow with an Actor is to have a public `UNiagaraSystem*` `UPROPERTY` that is set in Unreal Editor and a private `UNiagaraComponent` that is created from the `UNiagaraSystem*` on `BeginPlay` or some other gameplay event.
An instance is created from the asset using either `SpawnSystemAtLocation` or `SpawnSystemAttached` in `UNiagaraFunctionLibrary`.

Example header:
```c++
UCLASS()
class AMyParticles : public AActor
{
    GENERATED_BODY()
public:
    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = "MyCategory")
    UNiagaraSystem* NiagaraSystemAsset;
private:
    UNiagaraComponent* NiagaraSystemInstance;
}
```

Example implementation:
```c++
#include "NiagaraComponent.h"
#include "NiagaraFunctionLibrary.h"
#include "NiagaraSystem.h"

void AMyParticles::BeginPlay
{
    if (DamageNiagaraEffect->IsValid())
    {
        ParticleSystemInstance = UNiagaraFunctionLibrary::SpawnSystemAttached(
            ParticleSystemAsset, RootComponent, NAME_None,
            FVector::ZeroVector, FRotator::ZeroRotator, FVector::OneVector,
            EAttachLocation::Type::KeepWorldPosition, false,
            ENCPoolMethod::None);
    }
}
```

The `ENCPoolMethod` to use depend highly on the way the particle system is intended to be used.

Look for other useful stuff in `UNiagaraFunctionLibrary`.

## Setting variables

A particle system may expose user parameters.
