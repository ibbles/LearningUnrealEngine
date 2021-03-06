2020-05-08_22:05:51

## Static Mesh

A Static Mesh is a mesh in which the triangles and vertices don't move in relation to each other.
The alternative is a Skeletal Mesh.


## Triangles

The vertex positions are expressed in centimeters.
A cube with one corner vertex at (0.0, 0.0, 0.0) and the opposite corner vertex at (100.0, 100.0, 100.0) is a 1 meter cube.
Most 3D digital content creation (DCC) software can be set to use this unit in its settings.
To prevent scaling issues.

A `StaticMesh` is either imported, often from an `.fbx` file, or generated from a `RawMesh`.
A `RawMesh` is created from a list of shared vertex positions and per wedge positing index, normal, tangents, and texture coordinate.
Three wedges make up a triangles and is anchored at a vertex.
The wedge carries the index of the vertex's position, and the normal, tangents, and texture coordinate of the vertex.
A `StaticMesh` contains a number of `RawMesh`s in a list named `SourceModels`.

(
The following part is from before Nanite.
Still unclear what the guidelines for Nanite meshes are.
)

The number of triangles has a big impact on the rendering cost of a Static Mesh.
Avoid modeling small details with triangles.
Game models often have triangle budgets.

Each vertex can have multiple texture coordinates.
It is common to use the first one for color data, the regular texture.
It is common to use the second one for lightmap UVs.


## Materials

A static mesh has a number of material IDs.
Also called material slot.
There is at least one, ID 0.
Each triangle has a material ID.
Or inversely, each material slot maps to a set of triangles.
The Material ID determines which Material is applied to a particular triangle.
When a Material is assigned to a material ID the triangles with that Material ID is given that Material.

A mesh will be rendered once for each material ID that it has, plus one.
So keep the material count as low as possible.
Game models often have material ID budgets.
From just one for clutter and props, to two or three for prominent objects.

It is common to have "uber materials".
These are very flexible materials that use parameters, vertex properties, or texture samples to make different parts of the mesh look different even though they use the same material.

[[2020-05-10_11:01:04]] [Materials](./Materials.md)  


## Lightmaps

A Static Mesh can have a lightmap associated with it.
A lightmap is precomputed lighting information.
The properties for that lightmap are set in the Details Panel in the Static Mesh Editor.
Can set Light Map Resolution.
Can set Light Map Coordinate Index.
The light map resolution set on the Static Mesh Asset, in the Static Mesh Editor, can be override on a particular instance.
In the instance's Details Panel, search for Overridden Light Map Res.

[[2021-05-28_23:06:53]] [Lightmaps](./Lightmaps.md)  


## Pivot point

The Static Mesh's local origin.
The point that the Static Mesh will rotate/scale around.
The pivot point is defined by the digital content creation (DCC) software.
When creating the mesh, keep it centered around the origin in the DCC.
It may be possible to move it in Static Mesh Editor in Unreal Editor.


## Level of detail - LOD

A collection of meshes for the same model with decreasing triangle count and material complexity.
No need to render a high-poly mesh for a model that is very small on screen.
Higher LOD numbers mean cruder mesh, with 0 being the original, full detail mesh.
Lower LOD meshes often try to preserve the silhouette.
There is a trade-off between the number of LOD meshes and the visual impact of switching between them.
The reduction in rendering cost should offset the cost of having additional meshes.
A guideline is to have one with 75%, 35%, and 12% of the triangles or vertices.

The Tool Bar in the Static Mesh Editor has a combo box for switching between LODs.
When set the Auto the mesh rendered in the Viewport will switch automatically based on screen size.
The current LOD is printed in the status text in the top-left of the viewport.

The Details Panel in the Static Mesh Editor contains a category for each LOD level.
And a category for LOD Settings in general.
Selecting something in the Details Panel > LOD Settings > LOD Group combo box will cause a collection of LOD meshes to be created.
Settings for each type of automatic LOD creation is set in the engine settings / `Engine.ini`.


When importing an FBX with multiple LODs, enable FBX Import Options > Mesh > Import Mesh LODs.
Not sure how the importer decides which triangle belong to which LOD, and what the order of the LODs are.

[[2021-05-29_07:58:52]] [Import meshes](./Import%20meshes.md)  

Nanite is a separate way to handle level of detail.


## Collisions

A Static Mesh asset has a default collision preset that is applied when new Static Mesh Actors are created from the asset.
Changing the collision preset on the asset will update all Static Mesh instances that doesn't override the default.

[[2020-07-04_15:24:50]] [Collisions](./Collisions.md)  




[[2020-12-26_21:50:52]] [Skeletal Mesh](./Skeletal%20Mesh.md)  
[[2020-05-10_11:01:04]] [Materials](./Materials.md)  
[[2021-05-28_23:06:53]] [Lightmaps](./Lightmaps.md)  
[[2021-05-29_07:58:52]] [Import meshes](./Import%20meshes.md)  
[[2020-11-10_08:30:07]] [Collision shapes](./Collision%20shapes.md)  
[[2021-05-29_10:13:01]] [FBX](./FBX.md)  
