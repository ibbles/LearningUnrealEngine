2020-07-04_15:24:50

# Collisions

Collision handling is done with `Channels`.
A channel is just a name.
Collision objects, e.g., `Collision Box` decide how it should respond to collisions with the channels.
The options are:

- Ignore. Do nothing, the objects do not interact.
- Overlap. Overlaps are reported to the event and query systems, but does not affect physics.
- Block. Overlaps will be prevented, any motion that would lead to an overlap will be blocked.

Each collision object has an `Object Type` that is one of the channels.
The object type and the collision responses for the various other channles is specified in the `Collision` category of the collision object's Details panel, and then under `Collision Presets`. Must select `Custom...` collision preset to get all of the settings.

New channels are created and named in Project Settings > Engine > Collision.
There are a few built-in channels that are not listed in the settings:

- Visibility
- Camera
- Landscape
- WorldStatic
- WorldDynamic
- Pawn
- PhysicsBody
- Vehicle
- Destructible

