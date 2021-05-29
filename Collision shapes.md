2020-11-10_08:30:07

# Collision shapes

A Static Mesh can have collision shapes.
Collision shapes are what are sent to the physics engine.
Because doing collision detection on the high-polygon mesh is often not necessary and too expensive.
A collision shape on the Static Mesh is required for enabling Simulate Physics on a Static Mesh Component.

## Simple collision

Simple collisions are a collection of primitive or convex shapes that approximate the shape of the Static Mesh.

### Static mesh editor

Collision shapes are added in the Static Mesh Editor, in Top Menu Bar > Collision.
A number of collision primitives can be added.
Each shape is added, not replacing an existing one.
The collision shapes are listed under Details Panel > Collision > Primitives.
There is one array per shape type: sphere, box, capsule, convex, and tapered capsule.
The Details Panel doesn't support adding or deleting collision primities.
To delete a collision primitives select it in the viewport and press Delete.
A selected collision shape can be translated and rotated with the usual W, E, S controls.
By adding and positioning multiple shapes we can produce a combined shape that roughly matches the shape of our StaticMesh.
Another type of shape is K-DOP.
This is a family of convex hull shapes.
Adding one to the StaticMesh adds it to the Convex Elements list in Details Panel > Collision > Primitives.

### C++

The collision primitives are held by a class named `UBodySetup`.
`UStaticMesh` has a `UBodySetup` member named `BodySetup`.
`UBodySetup` contains a bunch of other stuff as well.
`UBodySet` has a `FKAggregateGeom` member named `AggGeom`.
`FKAggregateGeom` contains the same lists as we saw in the Collisions category of the Static Mesh's Details Panel.


## Complex collision

A complex collision is a secondary Static Mesh that is used for collision detection.
Use this when a collection of primitives is insufficient.

### Static mesh editor

It is set in Details Panel > Collision > Complex Collision Mesh.
It is possible to use the mesh itself as the complex collision mesh.
A Static Mesh can have multiple LODs.
It is never not a good idea to swap the collision mesh in the way a rendering mesh is swapped.
Therefore we set a single LOD to use for collisions in Details Panel > General Settings > LOD For Collision.

### C++

The `UStaticMesh` class has the two properties `UStaticMesh* ComplexCollisionMesh` and `int32 LODForCollision`.


## Convex decomposition

Convex decomposition is the process of approximating a mesh using a collection convex shapes.
Multiple simple convex shapes are often more performant than a single complicated highly detailed mesh.
A collection of convex shapes can often approximate a arbitrary shape quite well.

The Static Mesh Editor has a Convex Decomposition Panel.
If not, enable it in Top Menu Bar > Window > Convex Decomposition.


[[2020-07-04_15:24:50]] [Collisions](./Collisions.md)  
[[2020-11-10_08:30:07]] [Collision presets](./Collision%20presets.md)  
