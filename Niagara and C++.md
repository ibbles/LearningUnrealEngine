2020-10-19_11:22:12

# Niagara and C++

To use Niagara particle systems in C++:

Add `Niagra` and `NiagaraCore` as a `PublicDependencyModuleNames` in the module's `.Build.cs`.

Header:
```c++
#include "NiagaraFunctionLibrary.h"
#include "NiagaraSystem.h"
#include "Particles/ParticleSystem.h"

// Class definition
    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = Effects)
    UNiagaraSystem* NiagaraEffect;
```


Source:
```c++
    if (DamageNiagaraEffect)
    {
      UNiagaraFunctionLibrary::SpawnSystemAtLocation(this, DamageNiagaraEffect, GetActorLocation());
    }
```

Look for useful stuff in `UNiagaraFunctionLibrary`, which may have `SpawnSystemAttached`.

