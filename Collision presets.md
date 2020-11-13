2020-11-10_09:17:53

# Collision presets

Collision presets define a Static Mesh interacts with other Static Meshes.
The collision preset settings can be found on a Static Mesh's Details Panel > Collision > Collision Presets.
There are two dimensions to a collision preset: channel and response.
Channel specify to which type of objects the associated response should apply.
Response specify how a collision with one of the associated objects should be handled.
Channel can for example be WorldStatic, WorldDynamic, Pawn, PhysicsBody, or Vehicle.
Response can be either Ignore, Overlap, or Block.
- Ignore: The collision is ignored, nothing happens in response. It is as if the two objects existed in separate worlds.
- Overlap: The collision is detected and events generated, but the physics engine is not notified. So game logic can happen in response to the collision but there will be no bounce or any other physical effect.
- Block: Notify the physics engine about the collision. I assume that events are generated as well.

So one can imagine the collision preset as the folloring struct:
```c++
struct CollisionPreset
{
    ECollisionChannel Other;
    int32 bGenerateEvents : 1;
    int32 bNotifyPhysics : 1; 
}
```



[[2020-07-04_15:24:50]] [Collisions](./Collisions.md)  
[[2020-11-10_08:30:07]] [Collision shapes](./Collision%20shapes.md)
