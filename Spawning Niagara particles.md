2020-11-29_16:07:00

# Spawning Niagara particles

Spawning is the act of creating new particles.
Enable spawning by adding one of the spawning modules to the Emitter Update module stack group.
Unreal Engine ships with a few examples and we can make custom emitter modules.

After spawning the new particles are fed to the Particle Spawn module stack group.

Spawning is triggered by writing a Spawn Info parameter to the Output Map in the module.
The output parameter should have the name SpawnBurst.
The output parameter should have the `EMITTER` and `MODULE` Namespace Modifiers.

The particle system tracks particle spawning with sub-frame resolution.
Meaning that the particle system knows when during a frame a particular particle was spawned.
This is communicated from the module through the Interp Start Dt and Interval Dt Spawn Info parameters.



## Included emitter modules

In the following code snippets:
- Parameter names are prefixed with UPPER CASE labels for the Namespace Modifiers.

### Spawn Burst Instantaneously

Create a number of particles at a given point in time.
- `Spawn Count`: The number of particles to spawn.
- `Spawn Time`: The time point at which the particles will be spawned.
- `Age`: The clock which the Spawn Time is expressed in. Defaults to `EMITTER` `LoopedAge` .
- `Spawn Probability`: Set to < 1.0 to randomly not spawn any particles.
- `Spawn Group`: Group ID to assign to each spawned particle.

Module implementation:
```c++
struct FInputMap
{
    int32 INPUT.SpawnCount = 0;
    float INPUT.SpawnTime = 0.0f;
    float INPUT.Age = EMITTER.LoopedAge;
    int32 INPUT.SpawnGroup = 0;

    float ENGINE.DeltaTime;
    float EMITTER.LoopedAge = 0.0f;
    bool TRANSIENT.SpawningbCanEverSpawn = false;
};

struct FInputMap
{
    SpawnInfo EMITTER.MODULE.SpawnBurst;
    bool TRANSIENT.SpawningbCanEverSpawn
};

void SpawnBurstInstantaneous(FInputMap& InputMap, FOutputMap& OutputMap)
{
    float TimeLeft = InputMap.SpawnTime - InputMap.Age;
    float PrevAge = InputMap.Age - InputMap.DeltaTime;
    float PrevTimeLeft = InputMap.SpawnTime - PrevAge;
    bool bShouldHaveSpawned = TimeLeft < 0.0f;
    bool bHaveNotYetSpawned = PrevTimeLeft >= 0.0f;
    bool bDoSpawn = bShouldHaveSpawned && bHaveNotYetSpawned;
    if (bDoSpawn)
    {
        SpawnInfo SpawnBurst;
        SpawnInfo.Count = InputMap.SpawnCount;
        SpawnInfo.InterpStartDt = PrevTimeLeft;
        SpawnInfo.IntervalDt = 0.0f;
        SpawnInfo.NiagaraInt32 = InputMap.SpawnGroup;
        OutputMap.SpawnBurst = SpawnBurst;
    }
    else
    {
        SpawnInfo SpawnBurst;
        SpawnBurst.Count = 0;
        SpawnBurst.InterpStartDt = 0.0f;
        SpawnBurst.IntervalDt = 0.0f;
        SpawnBurst.NiagaraInt32 = InputMap.SpawnGroup;
        OutputMap.SpawnBurst = SpawnBurst;
    }

    bool bHaveNotYetSpawned = InputMap.LoopedAge <= InputMap.SpawnTime;
    bool bCanEverSpawn = InputMap.SpawningbCanEverSpawn;
    bCanEverSpawn = bCanEverSpawn || bHaveNotYetSpawned;
    OutputMap.SpawningbCanEverSpawn = bCanEverSpawn;
}
```

### Spawn Per Frame

Spawn a collection of particles each frame.
Do not use this module since it is framerate dependent.
- `Spawn Count`: The number of particles to spawn per frame.
- `Spawn Probability`: The likelihood that particles will be spawned a particular frame.
- `Spawn`: True to spawn particles, false to disable spawning.
- `Spawn Group`: Group ID to assign to each spawned particle.

```c++
struct FInputMap
{
    int32 INPUT.SpawnCount = 1;
    int32 INPUT.SpawnGroup = 0;
    bool INPUT.Spawn = true;

    float ENGINE.DeltaTime;

    bool TRANSIENT.SpawningbCanEverSpawn = false;
};

struct FOutputMap
{
    SpawnInfo EMITTER.MODULE.SpawnBurst;
    bool TRANSIENT.SpawningbCanEverSpawn;
};

void SpawnPerFrame(FInputMap& InputMap, FOutputMap& OutputMap)
{
    bool bDoSpawn = InputMap.Spawn
    if (bDoSpawn)
    {
        SpawnInfo SpawnBurst;
        SpawnBurst.Count = InputMap.SpawnCount;
        SpawnBurst.InterpStartDt = InputMap.DeltaTime;
        SpawnBurst.IntervalDt = 0.0f;
        SpawnBurst.NiagaraInt32 = InputMap.SpawnGroup;
        OutputMap.SpawnBurst = SpawnBurst;
    }
    else
    {
        SpawnInfo SpawnBurst;
        SpawnBurst.Count = 0;
        SpawnBurst.InterpStartDt = 0.0f;
        SpawnBurst.IntervalDt = 0.0f;
        SpawnBurst.NiagaraInt32 = InputMap.SpawnGroup;
        OutputMap.SpawnBurst = SpawnBurst;
    }

    bool bCanEverSpawn = InputMap.SpawningbCanEverSpawn;
    bCanEverSpawn = bCanEverSpawn || bDoSpawn;
    OutputMap.SpawningbCanEverSpawn = bCanEverSpawn;
}
```

### Spawn rate

Spawn a certain number of particles per second.
- `SpawnRate`: The number of particles to spawn per second.
- `SpawnGroup`: Group ID to assign to each spawned particle.

```c++
struct FInputMap
{
    float INPUT.SpawnRate = 0.0f;

    float EMITTER.LoopedAge = 0.0f;
    float EMITTER.MODULE.SpawnRemainder = 0.0f;

    float ENGINE.DeltaTime;
};

struct FOutputMap
{
};

void SpawnRate(FInputMap& InputMap, FOutputMap& OutputMap)
{
    float SpawnRate = InputMap.SpawnRate;
    float IntervalDT = 1.0f / SpawnRate;
    float InterpStartDT = IntervalDT * (1.0f - InputMap.SpawnRemainder);

    float DeltaTime = InputMap.DeltaTime;
    float Remainder = InputMap.SpawnRemainder;
    float LoopedAge = InputMap.LoopedAge;
    SpawnRate = LoopedAge >= 0.0f ? SpawnRate : 0.0f;
    float ToSpawn = SpawnRate * DeltaTime + Remainder;
    int32 SpawnCount = floor(ToSpawn);
    Remainder = ToSpawn - SpawnCount;

    OutputMap.SpawnRemainder = Remainder;


}
```



[[2020-11-18_17:39:27]] [Niagara](./Niagara.md)  