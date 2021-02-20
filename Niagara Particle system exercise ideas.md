2021-02-20_12:14:41

# Particle system exercise ideas


### Tornado from scratch

A swirl of particles affected by a circular inward-facing force field.
Create using a blank/empty system/emitter and using no pre-existing modules.
Should move across a Landscape.
Particle should bounce off of objects in the level.

### Keep max number

Continuation of the tornado.
Remove particles that move too far away from the tornado center.
Every now and then, spawn a bunch of particles so that a target number of particles exist.

Requirements:

- Burst spawning.
- Integer parameter.
- Current number of particles.


### Blueprint triggering

Trigger an emitter cycle on an existing particle system from a blueprint/C++.
For example to create a burst of some kind.


### Flow over mesh

Spawn particles that flow over the surface of a mesh.
Remove particles that fall too far off the mesh.

Requirements:

- Collision Query struct parameter.
- Age tracking that is reset on contact.


### C++ simulation

Do particle simulation in C++, pass particle data to Niagara through a data interface.


### SPH

Requirements: Neighbor lists.
This requires the new features that came to Niagara with Unreal Engine 4.26.


### CPU communication

Compute per-particle data in C++, access that data in a module.
