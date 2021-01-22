2020-11-21_17:37:59

# Advanced Niagara Effects | Inside Unreal

Notes from the YouTube video at https://www.youtube.com/watch?v=31GXFW-MgQk

Much of the examples discussed here are in the content examples.
I don't know how to get the content examples.
There are in the 4.26 content examples directory.

## World interaction

Niagara/world interfaces:
- Triangles  
    Niagara can read a model's triangles. For example to place particles on the surface of a model.
    Point Niagara to a specific mesh. Doesn't work well for things that cover the entire world.
- Physics Volumes  
    Can trace against physics volumes on the CPU.
    Physics meshes are often fairly coarse. Placing particles on it would make particles clip through the render mesh.
- Scene Depth  
    Find the closest opaque surface from the camera.
    Limited since only 2D, no information behind objects.
- Distance Fields  
    Can query distance fields and volume textures.
    Combination of accuracy and volumetric representation.

## Distance field

There is a global distance field.
A distance field is a volumetric texture where each voxel tells how close that voxel is to the nearest solid surface.
Niagara can query a specific location in world space to get the distance.
Can also sample multiple times near a point in a cross pattern to get a gradient and from that the direction of steepest decent, which is the shortest direction to the surface.
Using that information we can move the particle to the surface.

Sphere casting trace in a give direction.
Start at P0 and sample the distance field, them move along the direction that distance to P1.
You are guaranteed to not cross any surface.
Repeat.

Use the `Query MEsh Distance Field GPU` Module Function to query the distance field.
Pass in a Collision Query, which can be an input to the Module Function.
Use the `Sphere Trace Distance Field GPU` Module Function to run a ray cast.

## Continuous collision detection

Take an object at point A, where where it will be at point B, find any collision that will happen during traversal from point A to point B.
If there is an intervening collision, move the particle back to right at the collision, reflect, the velocity, and perform the remaining motion for the update/tick.
That's how the Collision module in Niagara works.

## Position based dynamics

Frame 1: Two particles are apart, one moving freely in space and the other resting on some geometry.
Frame 2: The free particle has moved into the resting particle.
Resolve by moving the two particles in opposite directions by an amount relative to their mass.
This may create new overlaps with other particles so the process must be iterated several times.
Derive a velocity from the change in position from the wanted position to the final position.


There is a PDB demo.
It's using Simulation Stages, which is still experimental in 4.25 and GPU-only.
Enabled in the Emitter's Emitter Properties module.
It has stages named "PopulateGrid", "ParticleCollisions", and "WorldCollisions".

[Unreal Engine Roadmap - Niagara Simulation Stages @ trello.com](https://trello.com/c/26ttfAdO/521-niagara-simulation-and-iteration-stages-experimental)  

## Flocks

Need to know about the world to be able to avoid it.
Need to know about each other, both to avoid and to communicate.
Each individual is an actor and only know certain things.
Building blocks of the behavior:
- Avoid the environment.
- Form clusters.
- Boid Proximity Avoidance.
- Match Velocities.
- Avoid head on collisions.

There is a `Avoid Distance Field Surfaces GPU` module.
Pushes particles away from any surface that is nearby using a normal force.
Also does forward line trace to find approaching obstacles.
Instead of applying a force normal force here we want to redirect the particle.
The force is applied along a cross product, not sure between which vectors.

Spatial hash, also called neighbor grid.
A way to find nearby particles.
All particles are bucketed into a spatial grid.
We can ask specific grid cells for their content.

Vision is done using a dot product with the particles velocity vector and the relative position of the other particle.
If in the interval `[cos(angle), 1.0]` then the other particle is seen.

This is a `Boid Force` module that does all this.

## Swarms

Insects that crawl on surfaces.
Must orient themselves to the surface they are on.

Place particles on the surface.
Spawn a bunch of particles.
Query distance field to find particles that are close to the surface, remove the rest.
This is called rejection sampling.
Move the remaining particles to the surface.
When a particle moves, perform the same operation again to stay on the surface.


## Animations and rendering

### Vertex animation textures
There is a tool called Vertex Animation Textures.
Converts mesh animations into vertex offset textures.
Bakes out morph targets of a skeletal mesh.
The texture data is used as a World Position Offset in the mesh's Material.
One row (or column) per frame/morph target in the animation, I assume.
Works well when the mesh is deforming in an organic manner.
Drawback is that the animation can't be applied to other mesh assets.

### Spline thickening
Done inside the material editor.
Each line a strip of polygons.
Thicken the polygons in the material editor.
Doesn't work well with vertex animation textures.


## Debug visualizations

Sprite Based Line module.
Give it two points and it will produces variables for drawing lines.

Text can be rendered with a material.
Use the Debug Float nodes.
Feed information from Niagara to the Material using a Dynamic Parameter.
Place a sprite renderer to the Emitter that uses the Material.

Better debug tools may come in the future.