2021-05-30_17:22:52

# Collision overlap event

A collision event, also called an overlap event, is when one collision volume overlap another collision volume and the collision preset is set to `Overlap`.
Examples of collision volumes are Static Mesh (I think), Box Collision and Sphere Collision.

We can bind hook up Visual Scripting Graph Nodes to such events in a Blueprint.
This is often used for trigger volumes.

It may be the case that only the Root Component in an Actor generates overlap events.
Experimentation needed.

[[2020-07-04_15:24:50]] [Collisions](./Collisions.md)  
[[2020-11-10_08:30:07]] [Collision shapes](./Collision%20shapes.md)  
[[2020-11-10_09:17:53]] [Collision presets](./Collision%20presets.md)  
[[2021-08-02_16:18:33]] [Trigger volume](./Trigger%20volume.md)  
